//
//  Created by onsissond.
//

import UIKit
import RxSwift
import ComposableArchitecture

enum StoriesPreviewSystem {
    typealias LocalStore = ComposableArchitecture.Store<State, Action>

    enum SubscriptionState: Equatable {
        case off
        case on
        case failure(UUID, needShowAlert: Bool)
    }
    enum SetupNotificationMode {
        case manual
        case automatic
    }
    struct State: Equatable {
        var storiesState: StoriesSystem.State?
        var stories: [Story] = []
        var futureStories: [Story] = []
        var futureStory: FutureStory?
        var subscriptionState: SubscriptionState = .off
    }
    enum Action: Equatable {
        case viewDidLoad
        case loadedStories(Stories)
        case setupFutureStories([Story])
        case switchNotifications
        case openStories(index: Int)
        case openSettings
        case dismissStories
        case setSubscriptionState(SubscriptionState)
        case setupNotification(SetupNotificationMode)
        case storiesAction(StoriesSystem.Action)
    }
    struct Environment {
        var fetchStories: () -> Effect<Stories>
        var currentDate: () -> Date
        var uuid: () -> UUID
        var calendar: () -> Calendar
        var notificationService: NotificationService
        var storiesEnvironment: StoriesSystem.Environment
    }
}

extension StoriesPreviewSystem.State {
    enum Item {
        case story(Story)
        case future(FutureStory)
    }

    var dataSource: [Item] {
        stories.map(Item.story) +
            (futureStory.map(Item.future).map { [$0] } ?? [])
    }
}

extension StoriesPreviewSystem {
    static var reducer = ComposableArchitecture.Reducer<State, Action, Environment> { state, action, env in
        switch action {
        case .viewDidLoad:
            state.subscriptionState = env.notificationService
                .notificationSettingsStorage
                .loadSubscriptionStatus()
                .map { .init($0, uuidProvider: env.uuid) }
                ?? .off
            return env.fetchStories().map(Action.loadedStories)
        case .loadedStories(let stories):
            state.stories = stories.activeStories
            return .init(value: .setupFutureStories(stories.futureStories))
        case .openStories(let index):
            state.storiesState = .init(
                stories: state.stories,
                currentStory: index
            )
            return .none
        case .setupFutureStories(let stories):
            state.futureStories = stories
            state.futureStory = state.futureStories.first.map {
                .init(
                    story: $0,
                    calendar: env.calendar(),
                    currentDate: env.currentDate()
                )
            }
            switch state.subscriptionState {
            case .on: return .init(value: .setupNotification(.automatic))
            case .off, .failure: return .none
            }
        case .openSettings:
            env.storiesEnvironment.storyEnvironment.openURL(
                URL(string: UIApplication.openSettingsURLString)!
            )
            return .none
        case .switchNotifications:
            switch state.subscriptionState {
            case .on:
                state.subscriptionState = .off
                env.notificationService.notificationSettingsStorage
                    .saveSubscriptionStatus(.off)
                env.notificationService.notificationProvider
                    .removeStoryNotifications()
            case .off, .failure:
                return .init(value: .setupNotification(.manual))
            }
            return .none
        case .setupNotification(let mode):
            env.notificationService.notificationProvider.removeStoryNotifications()
            return env.notificationService.notificationProvider.setupNotification(
                state.futureStories
            )
            .map { result -> StoriesPreviewSystem.SubscriptionState? in
                .init(result, mode: mode, uuidProvider: env.uuid)
            }
            .asObservable()
            .filterNil()
            .map(Action.setSubscriptionState)
            .eraseToEffect()
        case .setSubscriptionState(let value):
            state.subscriptionState = value
            env.notificationService.notificationSettingsStorage
                .saveSubscriptionStatus(.init(state: value))
            return .none
        case .dismissStories:
            state.storiesState = nil
            return .none
        case .storiesAction(.storyAction(_, .dismiss)):
            return Observable.just(())
                .map { .dismissStories }
                .eraseToEffect()
        case .storiesAction:
            return .none
        }
    }
    .combined(with: StoriesSystem.reducer.optional().pullback(
        state: \.storiesState,
        action: /Action.storiesAction,
        environment: \.storiesEnvironment
    ))
}

private extension StoriesPreviewSystem.SubscriptionState {
    init?(
        _ result: NotificationProvider.SetupNotificationResult,
        mode: StoriesPreviewSystem.SetupNotificationMode,
        uuidProvider: () -> UUID
    ) {
        switch result {
        case .success:
            self = .on
        case .failure:
            guard mode == .manual else {
                return nil
            }
            self = .failure(uuidProvider(), needShowAlert: true)
        }
    }
}

private extension NotificationSettingsStorage.StoriesSubscriptionStatus {
    init(state: StoriesPreviewSystem.SubscriptionState) {
        switch state {
        case .off: self = .off
        case .on: self = .on
        case .failure: self = .failure
        }
    }
}

private extension StoriesPreviewSystem.SubscriptionState {
    init(
        _ storiesSubscriptionStatus: NotificationSettingsStorage.StoriesSubscriptionStatus,
        uuidProvider: () -> UUID
    ) {
        switch storiesSubscriptionStatus {
        case .on:
            self = .on
        case .off:
            self = .off
        case .failure:
            self = .failure(uuidProvider(), needShowAlert: false)
        }
    }
}

private extension FutureStory {
    init(story: Story, calendar: Calendar, currentDate: Date) {
        self.init(
            imageURL: story.preview.imageURL,
            daysToFutureStory: {
                calendar.dateComponents(
                    [.day],
                    from: currentDate,
                    to: story.publishDate
                ).day ?? 0
            }()
        )
    }
}
