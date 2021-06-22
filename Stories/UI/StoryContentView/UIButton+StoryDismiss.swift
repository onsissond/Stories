//
//  Created by onsissond.
//

import UIKit

extension UIButton {
    static func makeStoryDismiss() -> UIButton {
        let button = UIButton()
        button.setImage(Asset.Icon.dismiss.image, for: .normal)
        return button
    }
}
