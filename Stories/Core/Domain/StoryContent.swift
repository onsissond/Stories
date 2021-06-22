//
// Copyright © 2021 LLC "Globus Media". All rights reserved.
//

import UIKit

enum StoryContent: Equatable {
    case regular(RegularStoryContent)
    case summary(SummaryStoryContent)
}

struct ImageStoryContent: Equatable {
    var imageURL: URL
}

struct RegularStoryContent: Equatable {
    struct Info: Equatable {
        var title: String
        var subtitle: String
    }
    var image: ImageStoryContent
    var title: String = ""
    var description: String = ""
    var periodInfo: Info?
    var priceInfo: Info?
}

struct SummaryStoryContent: Equatable {
    var image: ImageStoryContent
    var period: Period
    var title: String = ""
    var price: Price
    var deeplink: URL
    var trip: Trip
    var accommodation: Attachment
    var nutrition: Attachment
    var entertainment: Attachment
}

extension SummaryStoryContent {
    struct Period: Equatable {
        var title: String
        var value: String
    }

    struct Price: Equatable {
        var title: String
        var subtitle: String
        var value: String
    }

    struct Trip: Equatable {
        var to: TripInfo
        var from: TripInfo
    }

    struct Attachment: Equatable {
        var title: String
        var description: String
    }

    struct TripInfo: Equatable {
        var transport: Transport
        var title: String
        var subtitle: String
    }
}

// MARK: - Decodable
extension StoryContent: Decodable {
    enum CodingKeys: String, CodingKey {
        case type
    }

    enum ContentType: String, Decodable {
        case regular
        case summary
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ContentType.self, forKey: .type)
        switch type {
        case .regular:
            self = .regular(try RegularStoryContent(from: decoder))
        case .summary:
            self = .summary(try SummaryStoryContent(from: decoder))
        }
    }
}

extension RegularStoryContent: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case text
        case price
        case period
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        image = try ImageStoryContent(from: decoder)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .text)
        priceInfo = try container.decodeIfPresent(RegularStoryContent.Info.self, forKey: .price)
        periodInfo = try container.decodeIfPresent(RegularStoryContent.Info.self, forKey: .period)
    }
}

extension RegularStoryContent.Info: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle = "value"
    }
}

extension SummaryStoryContent: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case period
        case price
        case trip
        case deeplink
        case accommodation
        case nutrition
        case entertainment
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        image = try ImageStoryContent(from: decoder)
        title = try container.decode(String.self, forKey: .title)
        price = try container.decode(Price.self, forKey: .price)
        period = try container.decode(Period.self, forKey: .period)
        deeplink = try container.decode(URL.self, forKey: .deeplink)
        trip = try container.decode(Trip.self, forKey: .trip)
        accommodation = try container.decode(Attachment.self, forKey: .accommodation)
        nutrition = try container.decode(Attachment.self, forKey: .nutrition)
        entertainment = try container.decode(Attachment.self, forKey: .entertainment)
    }
}

extension SummaryStoryContent.Period: Decodable {}

extension SummaryStoryContent.Price: Decodable {}

extension SummaryStoryContent.Trip: Decodable {}

extension SummaryStoryContent.TripInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transport = try container.decode(Transport.self, forKey: .type)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decode(String.self, forKey: .description)
    }
}

extension SummaryStoryContent.Attachment: Decodable {}

extension ImageStoryContent: Decodable {
    enum CodingKeys: String, CodingKey {
        case image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageURL = try container.decode(URL.self, forKey: .image)
    }
}
