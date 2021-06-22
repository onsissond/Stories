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
        var stories: [Story] = []
        var futureStories: [Story] = []
        var futureStory: FutureStory?
        var subscriptionState: SubscriptionState = .off
    }
    enum Action: Equatable {
        case viewDidLoad
        case loadedStories([Story])
        case setupActiveStories([Story])
        case setupFutureStories([Story])
        case storesAction(StoriesSystem.Action)
        case switchNotifications
        case setSubscriptionState(SubscriptionState)
        case setupNotification(SetupNotificationMode)
    }
    struct Environment {
        var fetchStories: () -> ComposableArchitecture.Effect<[Story]>
        var currentDate: () -> Date
        var uuid: () -> UUID
        var notificationService: NotificationService
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
                .loadStoriesSubscriptionStatus()
                .map {
                    switch $0 {
                    case .on: return .on
                    case .off: return .off
                    case .failure: return .failure(env.uuid(), needShowAlert: false)
                    }
                } ?? .off
            return env.fetchStories().map(Action.loadedStories)
        case .loadedStories(let stories):
            return .merge(
                Observable.just((stories, env.currentDate()))
                    .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
                    .map { (stories, currentDate) in
                        stories.filter { story in
                            story.publishDate < currentDate &&
                                story.expireDate > currentDate
                        }
                    }
                    .map(Action.setupActiveStories)
                    .observeOn(MainScheduler.instance)
                    .eraseToEffect(),
                Observable.just((stories, env.currentDate()))
                    .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
                    .map { (stories, currentDate) in
                        stories.filter { $0.publishDate > env.currentDate() }
                            .sorted { $0.publishDate < $1.publishDate }
                    }
                    .map(Action.setupFutureStories)
                    .observeOn(MainScheduler.instance)
                    .eraseToEffect()
            )
        case .setupActiveStories(let stories):
            state.stories = stories
            return .none
        case .setupFutureStories(let stories):
            state.futureStories = stories
            if let nearestFutureStoryDate = state.futureStories
                .first.map(\.publishDate) {
                state.futureStory = .init(
                    daysToFutureStory: {
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.day], from: env.currentDate(), to: nearestFutureStoryDate)
                        return components.day ?? 0
                    }()
                )
            }
            switch state.subscriptionState {
            case .on:
                return .init(value: .setupNotification(.automatic))
            case .off, .failure:
                return .none
            }
        case .switchNotifications:
            switch state.subscriptionState {
            case .on:
                state.subscriptionState = .off
                env.notificationService.saveStoriesSubscriptionStatus(.off)
                env.notificationService.removeStoryNotifications()
            case .off, .failure:
                env.notificationService.saveStoriesSubscriptionStatus(.on)
                return .init(value: .setupNotification(.manual))
            }
            return .none
        case .setupNotification(let mode):
            env.notificationService.removeStoryNotifications()
            return Observable.just(state.futureStories)
                .subscribeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
                .flatMap { futureStories in
                    Observable.zip(
                        futureStories
                            .map(env.notificationService.setupNotification)
                    )
                }
                .map { result -> StoriesPreviewSystem.SubscriptionState? in
                    guard result.allSatisfy({ $0 == .success }) else {
                        guard mode == .manual else {
                            return nil
                        }
                        return .failure(env.uuid(), needShowAlert: true)
                    }
                    return .on
                }
                .filterNil()
                .map(Action.setSubscriptionState)
                .observeOn(MainScheduler.instance)
                .eraseToEffect()
        case .setSubscriptionState(let value):
            state.subscriptionState = value
            env.notificationService.saveStoriesSubscriptionStatus(
                .init(state: value)
            )
            return .none
        case .storesAction:
            return .none
        }
    }
}

extension StoriesSubscriptionStatus {
    init(state: StoriesPreviewSystem.SubscriptionState) {
        switch state {
        case .off: self = .off
        case .on: self = .on
        case .failure: self = .failure
        }
    }
}
