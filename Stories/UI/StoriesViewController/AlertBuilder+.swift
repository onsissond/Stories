//
//  Created by onsissond.
//

import ComposableArchitecture

extension AlertBuilder {
    func with<T>(
        alertState: ComposableArchitecture.AlertState<T>,
        sendAction: @escaping (T) -> Void
    ) -> AlertBuilder {
        var builder = with(title: alertState.title)
        if let message = alertState.message {
            builder = builder.with(message: message)
        }
        [alertState.primaryButton, alertState.secondaryButton].forEach {
            switch $0 {
            case .some(let button):
                switch button.type {
                case .cancel(let title):
                    guard let title = title else { break }
                    builder = builder.withCancel(title: title, action: {
                        guard let action = button.action else { return }
                        sendAction(action)
                    })
                case .default(let title):
                    builder = builder.withAction(title: title, isPreffered: true) {
                        guard let action = button.action else { return }
                        sendAction(action)
                    }
                case .destructive(let title):
                    builder = builder.withDestructive(title: title, action: {
                        guard let action = button.action else { return }
                        sendAction(action)
                    })
                }
            case .none:
                break
            }
        }
        return builder
    }
}
