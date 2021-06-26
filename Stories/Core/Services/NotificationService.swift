//
//  Created by onsissond.
//

import UIKit
import UserNotifications
import ComposableArchitecture
import RxSwift

private let storyIdentifierPrefix = "Story Notification"
private let subscriptionKey = "Stories Subsciption"

struct NotificationService {
    var setupNotification: (Story) -> Effect<SetupNotificationResult>
    var removeStoryNotifications: () -> Void
    var loadStoriesSubscriptionStatus: () -> StoriesSubscriptionStatus?
    var saveStoriesSubscriptionStatus: (StoriesSubscriptionStatus) -> Void
}

extension NotificationService {
    static var live = NotificationService(
        setupNotification: _setupNotification,
        removeStoryNotifications: _removeStoryNotifications,
        loadStoriesSubscriptionStatus: _loadStoriesSubscriptionStatus,
        saveStoriesSubscriptionStatus: _saveStoriesSubscriptionStatus
    )
}

enum SetupNotificationResult {
    case error
    case disabled
    case success
}

private func _setupNotification(story: Story) -> Effect<SetupNotificationResult> {
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]
    return Observable<SetupNotificationResult>.create { subscriber in
        notificationCenter.requestAuthorization(
            options: options
        ) { didAllow, _ in
            guard didAllow else {
                subscriber.onNext(.disabled)
                return
            }
            notificationCenter.add(_scheduleNotification(story: story)) { error in
                if error != nil {
                    subscriber.onNext(.error)
                    return
                }
                subscriber.onNext(.success)
            }
        }
        return Disposables.create()
    }
    .observeOn(MainScheduler.instance)
    .eraseToEffect()
}

private func _removeStoryNotifications() {
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.getPendingNotificationRequests { requests in
        let storiesIdentifiers = requests
            .map(\.identifier)
            .filter { $0.hasPrefix(storyIdentifierPrefix) }
        notificationCenter.removePendingNotificationRequests(
            withIdentifiers: storiesIdentifiers
        )
    }
}

enum StoriesSubscriptionStatus: String {
    case on, off, failure
}
private func _loadStoriesSubscriptionStatus() -> StoriesSubscriptionStatus? {
    UserDefaults.standard.string(forKey: subscriptionKey)
        .map { StoriesSubscriptionStatus(rawValue: $0)! }
}

private func _saveStoriesSubscriptionStatus(
    status: StoriesSubscriptionStatus
) {
    UserDefaults.standard.setValue(status.rawValue, forKeyPath: subscriptionKey)
}

extension UNMutableNotificationContent {
    convenience init(story: Story) {
        self.init()
        title = L10n.Notification.title
        subtitle = story.preview.title
        body = story.preview.description ?? ""
    }
}

private func _scheduleNotification(story: Story) -> UNNotificationRequest {
    let content = UNMutableNotificationContent(story: story)

    var triggerDate = Calendar.current.dateComponents(
        [.year, .month, .day, .hour, .minute, .second],
        from: story.publishDate
    )

    triggerDate.hour = 12

    let trigger = UNCalendarNotificationTrigger(
        dateMatching: triggerDate,
        repeats: false
    )

    let identifier = storyIdentifierPrefix.appending(story.id)
    return UNNotificationRequest(
        identifier: identifier,
        content: content,
        trigger: trigger
    )
}
