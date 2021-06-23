//
//  Created by onsissond.
//

import UIKit
import RxSwift
import ComposableArchitecture

enum StoriesSystem {
    typealias LocalStore = Store<State, Action>

    struct State: Equatable {
        var stories: [StorySystem.State]
        var currentStory = 0
        var dismiss = false
        var feedbackAlert: AlertState<Action>?
        var feedbackURL: URL?

        init(stories: [Story], currentStory: Int) {
            self.stories = stories.map(StorySystem.State.init)
            self.currentStory = currentStory
        }
    }

    enum Action: Equatable {
        case storyAction(storyIndex: Int, action: StorySystem.Action)
        case launchFeedback
        case launchedFeedback
        case dismissFeedbackAlert
    }
}

extension StoriesSystem {
    static var reducer = ComposableArchitecture.Reducer<State, Action, Void> { state, action, _ in
        switch action {
        case .launchFeedback:
            state.feedbackAlert = nil
            state.feedbackURL = URL(string: "https://www.google.com")!
        case .launchedFeedback:
            state.feedbackURL = nil
        case .dismissFeedbackAlert:
            state.feedbackAlert = nil
        case let .storyAction(index, .previousStory):
            if index - 1 >= 0 {
                state.currentStory = index - 1
                return .concatenate(
                    Effect(value: .storyAction(storyIndex: index, action: .nullify)),
                    Effect(value: .storyAction(storyIndex: state.currentStory, action: .run))
                )
            } else {
                return Effect(value: .storyAction(storyIndex: state.currentStory, action: .run))
            }
        case let .storyAction(index, .nextStory):
            if index + 1 < state.stories.count {
                state.currentStory = index + 1
                return .concatenate(
                    Effect(value: .storyAction(storyIndex: index, action: .finish)),
                    Effect(value: .storyAction(storyIndex: state.currentStory, action: .run))
                )
            } else {
                return Effect(value: .storyAction(storyIndex: index, action: .finish))
            }
        case .storyAction(_, .dismiss):
            state.dismiss = true
        case .storyAction(_, .requestFeedback):
            state.feedbackAlert = .feedback
        case .storyAction:
            return .none
        }
        return .none
    }
    .combined(
        with: StorySystem.reducer.forEach(
            state: \.stories,
            action: /StoriesSystem.Action.storyAction,
            environment: { _ in }
        )
    )
}
