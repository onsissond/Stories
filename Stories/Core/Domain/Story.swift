//
//  Created by onsissond.
//

import UIKit

struct Story: Equatable {
    var id: String
    var preview: RegularStoryPreview
    var content: [StoryContent]
    var publishDate: Date
    var expireDate: Date
}

// MARK: - Decodable
extension Story: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case pages
        case publishDate
        case expireDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        preview = try RegularStoryPreview(from: decoder)
        content = try container.decode([StoryContent].self, forKey: .pages)

        let publishDateString = try container.decode(String.self, forKey: .publishDate)
        let expireDateString = try container.decode(String.self, forKey: .expireDate)
        let dateFormatter = DateFormatter.plusThreeDateFormatter
        publishDate = dateFormatter.date(from: publishDateString)!
        expireDate = dateFormatter.date(from: expireDateString)!
    }
}

/// Вспомогательные функции для форматирования дат.
 extension DateFormatter {

     /// DateFormatter, настроенный на формат "yyyy-MM-dd" и на часовой пояс +3.
     public static var plusThreeDateFormatter: DateFormatter {
         let formatter = DateFormatter()

         formatter.timeZone = TimeZone(secondsFromGMT: 60*60*3)!
         formatter.dateFormat = "yyyy-MM-dd"

         return formatter
     }
 }
