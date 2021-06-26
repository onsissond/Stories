//
//  Created by onsissond.
//

import RxSwift
import UserNotifications

private let _storyIdentifierPrefix = "Story Notification"

struct NotificationProvider {
    var setupNotification: ([Story]) -> Single<SetupNotificationResult>
    var removeStoryNotifications: () -> Void
}

extension NotificationProvider {
    enum SetupNotificationResult {
        case failure
        case success
    }
}

extension NotificationProvider {
    static var live = NotificationProvider(
        setupNotification: _setupNotification(),
        removeStoryNotifications: { _removeStoryNotifications() }
    )
}

extension NotificationProvider {
    private static func _setupNotification(
        notificationCenter: UNUserNotificationCenter = .current(),
        options: UNAuthorizationOptions = [.alert, .sound],
        calendar: Calendar = .current,
        maxNotifications: Int = 10
    ) -> ([Story]) -> Single<SetupNotificationResult> {
        return { stories in
            .zip(stories.prefix(maxNotifications).map(
                _setupStoryNotification(
                    notificationCenter: notificationCenter,
                    options: options,
                    calendar: calendar
                )
            ))
            .map { results in
                results.allSatisfy { $0 == .success } ? .success : .failure
            }
        }
    }

    private static func _setupStoryNotification(
        notificationCenter: UNUserNotificationCenter = .current(),
        options: UNAuthorizationOptions = [.alert, .sound],
        calendar: Calendar = .current
    ) -> (Story) -> Single<SetupNotificationResult> {
        return { story in
            .create { subscriber in
                notificationCenter.requestAuthorization(
                    options: options
                ) { didAllow, _ in
                    guard didAllow else {
                        subscriber(.success(.failure))
                        return
                    }
                    notificationCenter.add(.init(
                        story: story,
                        calendar: calendar,
                        identifier: _storyIdentifierPrefix
                    )) { error in
                        guard error == nil else {
                            subscriber(.success(.failure))
                            return
                        }
                        subscriber(.success(.success))
                    }
                }
                return Disposables.create()
            }
            .subscribeOn(SerialDispatchQueueScheduler(qos: .utility))
            .observeOn(MainScheduler.instance)
        }
    }


    private static func _removeStoryNotifications(
        notificationCenter: UNUserNotificationCenter = .current()
    ) {
        notificationCenter.getPendingNotificationRequests { requests in
            let storiesIdentifiers = requests
                .map(\.identifier)
                .filter { $0.hasPrefix(_storyIdentifierPrefix) }
            notificationCenter.removePendingNotificationRequests(
                withIdentifiers: storiesIdentifiers
            )
        }
    }
}

private extension UNMutableNotificationContent {
    convenience init(story: Story) {
        self.init()
        title = L10n.Notification.title
        subtitle = story.preview.title
        body = story.preview.description ?? ""
    }
}


private extension UNNotificationRequest {
    convenience init(story: Story, calendar: Calendar, identifier: String) {
        let content = UNMutableNotificationContent(story: story)
        var triggerDate = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: story.publishDate
        )
        triggerDate.hour = 12

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: triggerDate,
            repeats: false
        )
        let identifier = identifier.appending(story.id)
        self.init(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
    }
}
