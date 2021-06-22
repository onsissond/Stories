//
//  Created by onsissond.
//

import UIKit

public enum AlertType {
    case alert
    case actionSheet

    var prefferedStyle: UIAlertController.Style {
        switch self {
        case .alert:
            return .alert
        case .actionSheet:
            return .actionSheet
        }
    }
}

public final class AlertBuilder {

    private let _alert: UIAlertController

    public init(_ alertType: AlertType = .alert) {
        _alert = UIAlertController(
            title: "",
            message: nil,
            preferredStyle: alertType.prefferedStyle
        )
    }

    public func with(title: String) -> AlertBuilder {
        _alert.title = title
        return self
    }

    public func with(message: String) -> AlertBuilder {
        _alert.message = message
        return self
    }

    public func withAction(title: String, isPreffered: Bool = false, action: (() -> Void)? = nil) -> AlertBuilder {
        let newAlertAction = UIAlertAction(title: title, style: .default) { _ in action?() }
        _alert.addAction(newAlertAction)
        if isPreffered {
            _alert.preferredAction = newAlertAction
        }
        return self
    }

    public func withDestructive(title: String, action: (() -> Void)? = nil) -> AlertBuilder {
        let newAlertAction = UIAlertAction(title: title, style: .destructive) { _ in action?() }
        _alert.addAction(newAlertAction)
        return self
    }

    public func withCancel(title: String, action: (() -> Void)? = nil) -> AlertBuilder {
        let newAlertAction = UIAlertAction(title: title, style: .cancel) { _ in action?() }
        _alert.addAction(newAlertAction)
        return self
    }

    public func build() -> UIAlertController {
        _alert
    }
}
