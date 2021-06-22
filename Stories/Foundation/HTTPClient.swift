//
//  Created by onsissond.
//

import Moya

public typealias HTTPClient = MoyaProvider<MultiTarget>

#if DEBUG
extension MoyaProvider {
    public static var mock: MoyaProvider {
        MoyaProvider(
            endpointClosure: MoyaProvider.defaultEndpointMapping,
            stubClosure: MoyaProvider.immediatelyStub
        )
    }
}
#endif
