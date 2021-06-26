//
//  Created by onsissond.
//

import RxSwift

struct Stories: Equatable {
    var activeStories: [Story]
    var futureStories: [Story]
}

struct StoriesService {
    typealias FetchStories = (_ date: Date) -> Single<Stories>
    var fetchStories: (HTTPClient) -> FetchStories
}

extension StoriesService {
    static var live = StoriesService(
        fetchStories: _fetchStories
    )
}

extension StoriesService {
    private static var _fetchStories: (HTTPClient) -> FetchStories = { httpClient in
        return { currentDate in
            httpClient.fetchStories
                .observeOn(SerialDispatchQueueScheduler(qos: .userInteractive))
                .map { stories in
                    stories.sorted { $0.publishDate < $1.publishDate }
                }
                .map { stories in
                    Stories(
                        activeStories: stories.filter {
                            $0.publishDate < currentDate &&
                                $0.expireDate > currentDate
                        },
                        futureStories: stories.filter {
                            $0.publishDate > currentDate
                        }
                    )
                }
                .observeOn(MainScheduler.instance)
        }
    }
}
