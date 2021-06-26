//
//  Created by onsissond.
//

private let subscriptionKey = "Stories Subsciption"

struct NotificationSettingsStorage {
    var loadSubscriptionStatus: () -> StoriesSubscriptionStatus?
    var saveSubscriptionStatus: (StoriesSubscriptionStatus) -> Void
}

extension NotificationSettingsStorage {
    enum StoriesSubscriptionStatus: String {
        case on, off, failure
    }
}

extension NotificationSettingsStorage {
    static var live = NotificationSettingsStorage(
        loadSubscriptionStatus: _loadStoriesSubscriptionStatus(),
        saveSubscriptionStatus: _saveStoriesSubscriptionStatus()
    )
}

extension NotificationSettingsStorage {
    private static func _loadStoriesSubscriptionStatus(
        userDefaults: UserDefaults = .standard
    ) -> () -> StoriesSubscriptionStatus? {
        return {
            userDefaults.string(forKey: subscriptionKey)
                .map { StoriesSubscriptionStatus(rawValue: $0)! }
        }
    }

    private static func _saveStoriesSubscriptionStatus(
        userDefaults: UserDefaults = .standard
    ) -> (StoriesSubscriptionStatus) -> Void {
        return { status in
            UserDefaults.standard.setValue(
                status.rawValue,
                forKeyPath: subscriptionKey
            )
        }
    }
}
