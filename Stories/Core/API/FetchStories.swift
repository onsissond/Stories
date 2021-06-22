//
// Copyright © 2021 LLC "Globus Media". All rights reserved.
//

import RxSwift
import Moya
import RxMoya

typealias FetchStories = () -> Single<[Story]>

extension HTTPClient {
    var fetchStories: FetchStories {
        return {
            self.rx
                .request(MultiTarget(FetchStoriesRequest()))
                .map([Story].self)
                .catchErrorJustReturn([])
                .observeOn(MainScheduler.instance)
        }
    }
}
