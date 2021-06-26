//
//  Created by onsissond.
//

struct NotificationService {
    var notificationProvider: NotificationProvider
    var notificationSettingsStorage: NotificationSettingsStorage
}

extension NotificationService {
    static var live = NotificationService(
        notificationProvider: .live,
        notificationSettingsStorage: .live
    )
}
