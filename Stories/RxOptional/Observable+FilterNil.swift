//
//  Created by onsissond.
//

import RxSwift

public extension ObservableType where Element: OptionalType {
  /**
   Unwraps and filters out `nil` elements.
   - returns: `Observable` of source `Observable`'s elements, with `nil` elements filtered out.
   */

  func filterNil() -> Observable<Element.Wrapped> {
    return flatMap { element -> Observable<Element.Wrapped> in
      guard let value = element.value else {
        return Observable<Element.Wrapped>.empty()
      }
      return Observable<Element.Wrapped>.just(value)
    }
  }
}

public protocol OptionalType {
  associatedtype Wrapped
  var value: Wrapped? { get }
}

extension Optional: OptionalType {
  /// Cast `Optional<Wrapped>` to `Wrapped?`
  public var value: Wrapped? {
    return self
  }
}
