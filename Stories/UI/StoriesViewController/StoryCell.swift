//
//  Created by onsissond.
//

import UIKit
import ComposableArchitecture
import RxSwift

enum StorySystem {
    typealias LocalStore = Store<State, Action>
    typealias LocalViewStore = ViewStore<State, Action>

    struct State: Equatable {
        var story: Story
        var progressState: InstaProgressView.ViewState
        var currentPage: Int {
            get { progressState.currentPage }
            set { progressState.currentPage = newValue }
        }

        init(story: Story) {
            self.story = story
            progressState = InstaProgressView.ViewState(
                pagesCount: story.content.count,
                progress: story.content.map { _ in .initial },
                currentPage: 0
            )
        }
    }

    enum Action: Equatable {
        case nextStory
        case previousStory
        case nextPage
        case previousPage
        case finish
        case run
        case nullify
        case pause
        case `continue`
        case dismiss
        case openDeepLink(URL)
        case requestFeedback
    }
}

extension StorySystem {
    static var reducer = Reducer<State, Action, Void> { state, action, _ in
        switch action {
        case .nextPage:
            if state.currentPage == state.story.content.count - 1 {
                return Effect(value: .nextStory)
            } else if state.currentPage < state.story.content.count - 1 {
                state.progressState.progress[state.currentPage] = .finish
                state.currentPage += 1
                state.progressState.progress[state.currentPage] = .start(UUID())
            }
        case .previousPage:
            if state.currentPage == 0 {
                return Effect(value: .previousStory)
            } else if state.currentPage > 0 {
                state.progressState.progress[state.currentPage] = .initial
                state.currentPage -= 1
                state.progressState.progress[state.currentPage] = .start(UUID())
            }
        case .run:
            for index in (0..<state.progressState.pagesCount) {
                if index < state.currentPage {
                    state.progressState.progress[index] = .finish
                } else if index == state.currentPage {
                    state.progressState.progress[index] = .start(UUID())
                } else {
                    state.progressState.progress[index] = .initial
                }

            }
        case .nullify:
            state.progressState.progress = state.progressState.progress
                .map { _ in .initial }
        case .finish:
            state.progressState.progress[state.currentPage] = .finish
        case .pause:
            state.progressState.progress[state.currentPage] = .pause
        case .continue:
            state.progressState.progress[state.currentPage] = .continue
        case let .openDeepLink(url):
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case .nextStory, .previousStory, .dismiss, .requestFeedback:
            break
        }
        return .none
    }
}

protocol StoryContentView: UIView {
    func render(viewState: StoryContent) -> Bool
}

class StoryCell: UICollectionViewCell {
    private lazy var _storyContentView = SwitchableView(contentViews: [
        _createRegularContentStoryView(),
        _createSummaryContentStoryView()
    ])
    private lazy var _progressView = InstaProgressView(
        progressTintColor: .white,
        trackTintColor: UIColor.white.withAlphaComponent(0.5),
        spaceBetweenSegments: 8,
        duration: 10
    )

    private lazy var _reusableDisposeBag = DisposeBag()
    private lazy var _disposeBag = DisposeBag()
    private var _viewStore: StorySystem.LocalViewStore?
    private lazy var _dataSource = PublishSubject<InstaProgressView.ViewState>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupSubviews()
        _setupAppearence()
        _setupGesturesRecognizers()
        _setupSubscriptions()
        _progressView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupAppearence() {
        contentView.clipsToBounds = true
    }

    private func _setupSubscriptions() {
        _dataSource
            .distinctUntilChanged()
            .bind(onNext: { [weak self] in
                self?._progressView.render(
                    viewState: $0
                )
            })
            .disposed(by: _disposeBag)
    }

    private func _setupSubviews() {
        contentView.addSubview(_storyContentView)
        _storyContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _storyContentView.topAnchor.constraint(equalTo: topAnchor),
            _storyContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            _storyContentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            _storyContentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        contentView.addSubview(_progressView)
        if hasEyebrow {
            _progressView.topAnchor.constraint(equalTo: topAnchor, constant: 48).isActive = true
        } else {
            _progressView.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        }
        _progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        _progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        _progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        _progressView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func _createRegularContentStoryView() -> StoryContentView {
        let view = RegularContentStoryView()
        view.events.bind(onNext: { [weak self] in
            switch $0 {
            case .dismiss:
                self?._viewStore?.send(.dismiss)
            }
        }).disposed(by: _disposeBag)
        return view
    }

    private func _createSummaryContentStoryView() -> StoryContentView {
        let view = SummaryContentStoryView()
        view.events.bind(onNext: { [weak self] in
            switch $0 {
            case .dismiss:
                self?._viewStore?.send(.dismiss)
            case let .openDeeplink(url):
                self?._viewStore?.send(.openDeepLink(url))
            case .requestFeedback:
                self?._viewStore?.send(.requestFeedback)
            }
        }).disposed(by: _disposeBag)
        return view
    }

    private func _setupGesturesRecognizers() {
        let swipeLeft = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        addGestureRecognizer(swipeLeft)
    }

    @objc private func handleGesture(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        if location.x < layer.frame.size.width / 2 {
            _viewStore?.send(.previousPage)
        } else {
            _viewStore?.send(.nextPage)
        }
    }
}

extension StoryCell {
    func render(store: StorySystem.LocalStore) {
        _viewStore = ViewStore(store)
        _reusableDisposeBag = DisposeBag()
        _viewStore?.publisher.subscribe(onNext: { [weak self] in
            _ = self?._storyContentView.render(
                viewState: $0.story.content[$0.currentPage]
            )
        }).disposed(by: _reusableDisposeBag)

        _viewStore?.publisher.map(\.progressState)
            .subscribe(onNext: _dataSource.onNext)
            .disposed(by: _reusableDisposeBag)
    }
}

extension StoryCell: InstaProgressViewDelegate {
    func next() {
        _viewStore?.send(.nextPage)
    }

    func back() {
        _viewStore?.send(.previousStory)
    }
}

extension UIView {
    var hasEyebrow: Bool {
        UIScreen.main.bounds.height >= 812
    }
}
