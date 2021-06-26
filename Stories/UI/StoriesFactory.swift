//
//  Created by onsissond.
//

import RxSwift
import UIKit

public enum StoriesFactory {
    public struct Dependency {
        var httpClient: HTTPClient
        var dateProvider: () -> Date
        var openURL: (URL) -> Void

        public init(
            httpClient: HTTPClient = .mock,
            dateProvider: @escaping () -> Date,
            openURL: @escaping (URL) -> Void
        ) {
            self.httpClient = httpClient
            self.dateProvider = dateProvider
            self.openURL = openURL
        }
    }

    public static func create(
        dependency: Dependency,
        payload: Void
    ) -> UIViewController {
        StoriesPreviewViewController(
            store: StoriesPreviewSystem.LocalStore(
                initialState: .init(),
                reducer: StoriesPreviewSystem.reducer,
                environment: StoriesPreviewSystem.Environment(
                    dependency: dependency
                )
            )
        )
    }
}

private extension StoriesPreviewSystem.Environment {
    init(
        dependency: StoriesFactory.Dependency
    ) {
        self.init(
            fetchStories: {
                dependency.httpClient.fetchStories()
                    .asObservable()
                    .eraseToEffect()
            },
            currentDate: dependency.dateProvider,
            uuid: UUID.init,
            calendar: { Calendar.current },
            notificationService: .live,
            storiesEnvironment: .init(
                storyEnvironment: .init(
                    openURL: dependency.openURL
                )
            )
        )
    }
}
