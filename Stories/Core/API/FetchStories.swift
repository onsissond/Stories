//
//  Created by onsissond.
//

import RxSwift
import Moya
import RxMoya

extension HTTPClient {
    var fetchStories: Single<[Story]> {
        rx.request(MultiTarget(FetchStoriesRequest()))
            .subscribeOn(SerialDispatchQueueScheduler(qos: .utility))
            .map([Story].self)
            .catchErrorJustReturn([])
            .observeOn(MainScheduler.instance)
    }
}
