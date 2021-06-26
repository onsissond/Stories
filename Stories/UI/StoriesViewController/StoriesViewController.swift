//
//  Created by onsissond.
//

import UIKit
import RxSwift
import ComposableArchitecture

enum StoriesCellIdentifier: String {
    case regular
}
class StoriesViewController: UIViewController {
    private let _store: StoriesSystem.LocalStore
    private let _disposeBag = DisposeBag()
    private lazy var _viewStore = ViewStore(_store)
    private var _viewTranslation = CGPoint.zero

    private lazy var collectionView: UICollectionView = {
        $0.bounces = false
        $0.isScrollEnabled = false
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(
            StoryCell.self,
            forCellWithReuseIdentifier: StoriesCellIdentifier.regular.rawValue
        )
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: .cube))

    init(store: StoriesSystem.LocalStore) {
        _store = store
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _setupGesturesRecognizers()
        _setupSubviews()
        _setupSubscriptions()
        _startCurrentStory()
    }

    private func _startCurrentStory() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self._store.state.currentStory != 0 {
                self.collectionView.selectItem(
                    at: .init(row: self._store.state.currentStory, section: 0),
                    animated: false,
                    scrollPosition: .centeredHorizontally
                )
            }
            self._viewStore.send(.storyAction(
                storyIndex: self._viewStore.state.currentStory,
                action: .run
            ))
        }
    }

    private func _setupSubscriptions() {
        _viewStore.publisher.map(\.currentStory)
            .distinctUntilChanged()
            .bind(onNext: { [weak self] currentStory in
                self?.collectionView.selectItem(
                    at: IndexPath(row: currentStory, section: 0),
                    animated: true,
                    scrollPosition: .centeredHorizontally
                )
            })
            .disposed(by: _disposeBag)

        _viewStore.publisher.map(\.feedbackAlert)
            .distinctUntilChanged()
            .filterNil()
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.present(
                    AlertBuilder()
                        .with(alertState: $0, sendAction: self._viewStore.send)
                        .build(),
                    animated: true
                )
            })
            .disposed(by: _disposeBag)

        _viewStore.publisher.map(\.feedbackURL)
            .distinctUntilChanged()
            .filterNil()
            .bind(onNext: { [weak self] in
                let webView = WKWebViewController()
                webView.presentationController?.delegate = self
                webView.render(viewState: $0)
                self?.present(webView, animated: true, completion: {
                    self?._viewStore.send(.launchedFeedback)
                })
            })
            .disposed(by: _disposeBag)
    }

    private func _setupSubviews() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension StoriesViewController {
    private func _setupGesturesRecognizers() {
        let longPressRecognizer = UILongPressGestureRecognizer(
            target: self, action: #selector(longPressed)
        )
        longPressRecognizer.minimumPressDuration = 0.2
        view.addGestureRecognizer(longPressRecognizer)

        view.addGestureRecognizer(UIPanGestureRecognizer(
            target: self, action: #selector(handleDismiss)
        ))
    }

    @objc private func longPressed(sender: UILongPressGestureRecognizer) {
        guard let indexPath = collectionView.indexPathsForVisibleItems.first else {
            return
        }
        if sender.state == .began {
            _viewStore.send(.storyAction(storyIndex: indexPath.row, action: .pause))
        } else if sender.state == .ended {
            _viewStore.send(.storyAction(storyIndex: indexPath.row, action: .continue))
        }
    }

    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            _viewTranslation = sender.translation(in: view)
            if _viewTranslation.y < 0 { break }
            _viewStore.send(
                .storyAction(storyIndex: _viewStore.currentStory, action: .pause)
            )
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 1,
                options: .curveEaseOut,
                animations: {
                self.view.transform = CGAffineTransform(
                    translationX: 0,
                    y: self._viewTranslation.y
                )
            })
        case .ended:
            if _viewTranslation.y < 200 {
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    options: .curveEaseOut,
                    animations: { [weak self] in
                        self?.view.transform = .identity
                    },
                    completion: { [weak self] _ in
                        guard let self = self else { return }
                        self._viewStore.send(.storyAction(
                            storyIndex: self._viewStore.currentStory,
                            action: .continue
                        ))
                    })
            } else {
                _viewStore.send(.storyAction(
                    storyIndex: _viewStore.currentStory,
                    action: .dismiss
                ))
            }
        default:
            break
        }
    }
}

extension StoriesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        _store.state.stories.count
    }
}

extension StoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoriesCellIdentifier.regular.rawValue,
            for: indexPath
        )
        if let cell = cell as? StoryCell {
            cell.render(store: _store.scope(
                state: \.stories[indexPath.row],
                action: { .storyAction(storyIndex: indexPath.row, action: $0) }
            ))
        }
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        view.bounds.size
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        .zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
}

extension StoriesViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(
        _ presentationController: UIPresentationController
    ) {
        _viewStore.send(.storyAction(
            storyIndex: _viewStore.state.currentStory,
            action: .continue
        ))
    }
}

extension AlertState where Action == StoriesSystem.Action {
    static var feedback = AlertState<StoriesSystem.Action>(
        title: L10n.Alert.Feedback.title,
        message: L10n.Alert.Feedback.message,
        primaryButton: .cancel(
            L10n.Alert.Feedback.Button.cancel,
            send: .dismissFeedbackAlert
        ),
        secondaryButton: .default(
            L10n.Alert.Feedback.Button.ok,
            send: .launchFeedback
        )
    )
}

