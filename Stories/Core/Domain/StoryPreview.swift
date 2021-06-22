//
// Copyright © 2021 LLC "Globus Media". All rights reserved.
//

import UIKit

struct RegularStoryPreview: Equatable {
    var title: String
    var description: String?
    var imageURL: URL?
}

extension RegularStoryPreview: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case description = "subtitle"
        case image = "thumb"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        imageURL = try URL(string: container.decode(String.self, forKey: .image))
    }
}
