//
//  Created by onsissond.
//

import Foundation

extension Date {
    static var mock: Date {
        Date(timeIntervalSinceReferenceDate: 0)
    }

    static func mock(
        _ stringValue: String,
        dateFormat: String = "yyyy-MM-dd HH:mm:ss",
        timeZone: TimeZone = .current
    ) -> Date? {
        let formatter: DateFormatter = {
            $0.dateFormat = dateFormat
            $0.timeZone = timeZone
            return $0
        }(DateFormatter())
        return formatter.date(from: stringValue)
    }
}
