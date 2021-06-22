//
//  Created by onsissond.
//

import UIKit
import RxSwift
import ComposableArchitecture

enum StoriesPreviewCellIdentifier: String {
    case regular
    case future
}

class StoriesPreviewViewController: UIViewController {
    private let _store: StoriesPreviewSystem.LocalStore
    private let _disposeBag = DisposeBag()
    private lazy var _viewStore = ViewStore(_store)

    private lazy var _collectionView: UICollectionView = {
        $0.contentInset = .init(top: 4, left: 16, bottom: 4, right: 16)
        $0.showsHorizontalScrollIndicator = false
        $0.register(
            StoryPreviewCell.self,
            forCellWithReuseIdentifier: StoriesPreviewCellIdentifier.regular.rawValue
        )
        $0.register(
            FutureStoryPreviewCell.self,
            forCellWithReuseIdentifier: StoriesPreviewCellIdentifier.future.rawValue
        )
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: _flowLayout))

    private lazy var _flowLayout: UICollectionViewFlowLayout = {
        $0.scrollDirection = .horizontal
        return $0
    }(UICollectionViewFlowLayout())

    init(store: StoriesPreviewSystem.LocalStore) {
        _store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _setupAppearence()
        _setupSubviews()
        _setupSubscriptions()
        _viewStore.send(.viewDidLoad)
    }

    private func _setupSubscriptions() {
        _viewStore.publisher.map(\.stories)
            .distinctUntilChanged()
            .bind(onNext: { [weak self] _ in
                self?._collectionView.reloadData()
            })
            .disposed(by: _disposeBag)

        _viewStore.publisher.map(\.subscriptionState)
            .distinctUntilChanged()
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                if let row = self._store.state.dataSource.firstIndex(where: {
                    if case .future = $0 { return true }
                    return false
                }) {
                    self._collectionView.reloadItems(
                        at: [.init(row: row, section: 0)]
                    )
                }
            })
            .subscribe()
            .disposed(by: _disposeBag)

        _viewStore.publisher.map(\.subscriptionState)
            .bind(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .failure(_, let needShowAlert) where needShowAlert == true:
                    self._showTurnOnNotificationAlert()
                default:
                    break
                }
            })
            .disposed(by: _disposeBag)
    }

    private func _setupAppearence() {
        _collectionView.backgroundColor = .clear
        view.backgroundColor = .white
    }

    private func _setupSubviews() {
        view.addSubview(_collectionView)
        _collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            _collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            _collectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func _showTurnOnNotificationAlert() {
        present(
            AlertBuilder()
                .with(title: L10n.Alert.TurnOnNotifications.title)
                .with(message: L10n.Alert.TurnOnNotifications.message)
                .withAction(title: L10n.Alert.TurnOnNotifications.Button.cancel)
                .withAction(title: L10n.Alert.TurnOnNotifications.Button.ok, isPreffered: true) {
                    UIApplication.shared.open(
                        URL(string: UIApplication.openSettingsURLString)!
                    )
                }
                .build(),
            animated: true
        )
    }
}

extension StoriesPreviewViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        _store.state.dataSource.count
    }
}

extension StoriesPreviewViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch _store.state.dataSource[indexPath.row] {
        case .story:
            present(
                StoriesViewController(store: .init(
                    initialState: .init(
                        stories: _store.state.stories,
                        currentStory: indexPath.row
                    ),
                    reducer: StoriesSystem.reducer,
                    environment: ()
                )),
                animated: true
            )
        case .future:
            _viewStore.send(.switchNotifications)
        }
    }
}

extension StoriesPreviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch _store.state.dataSource[indexPath.row] {
        case .story(let story):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StoriesPreviewCellIdentifier.regular.rawValue,
                for: indexPath
            )
            if let cell = cell as? StoryPreviewCell {
                cell.render(viewState: story.preview)
            }
            return cell
        case .future(let story):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StoriesPreviewCellIdentifier.future.rawValue,
                for: indexPath
            )
            if let cell = cell as? FutureStoryPreviewCell {
                cell.render(viewState: .init(
                    futureStory: story,
                    subscriptionState: _store.state.subscriptionState
                ))
            }
            return cell
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 112, height: 142)
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
        8
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
}

private extension FutureStoryPreviewCell.ViewState {
    init(
        futureStory: FutureStory,
        subscriptionState: StoriesPreviewSystem.SubscriptionState
    ) {
        self.init(
            subscriptionState: .init(subscriptionState: subscriptionState),
            daysToFutureStory: futureStory.daysToFutureStory
        )
    }
}

private extension FutureStoryPreviewCell.ViewState.SubscriptionState {
    init(subscriptionState: StoriesPreviewSystem.SubscriptionState) {
        switch subscriptionState {
        case .failure: self = .failure
        case .off: self = .off
        case .on: self = .on
        }
    }
}
