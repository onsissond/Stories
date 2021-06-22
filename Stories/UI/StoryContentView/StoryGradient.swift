//
//  Created by onsissond.
//

import UIKit

extension CAGradientLayer {
    static var storyGradient: CAGradientLayer {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor(hex: 0xF1D2F).withAlphaComponent(0.53).cgColor,
            UIColor(hex: 0x11834).cgColor
        ]
        layer.locations = [0, 0.5, 1]
        return layer
    }
}
