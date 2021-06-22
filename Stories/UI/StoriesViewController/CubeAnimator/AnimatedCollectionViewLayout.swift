//
//  Created by onsissond.
//

import UIKit

extension UICollectionViewLayout {
    static var cube: UICollectionViewLayout {
        let layout = AnimatedCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.animator = CubeAttributesAnimator()
        return layout
    }
}

class AnimatedCollectionViewLayout: UICollectionViewFlowLayout {

    /// The animator that would actually handle the transitions.
    var animator: LayoutAttributesAnimator?

    /// Overrided so that we can store extra information in the layout attributes.
    override class var layoutAttributesClass: AnyClass { return AnimatedCollectionViewLayoutAttributes.self }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        return attributes.compactMap { $0.copy() as? AnimatedCollectionViewLayoutAttributes }.map { self.transformLayoutAttributes($0) }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // We have to return true here so that the layout attributes would be recalculated
        // everytime we scroll the collection view.
        return true
    }

    private func transformLayoutAttributes(_ attributes: AnimatedCollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        guard let collectionView = self.collectionView else { return attributes }

        let a = attributes

        /**
         The position for each cell is defined as the ratio of the distance between
         the center of the cell and the center of the collectionView and the collectionView width/height
         depending on the scroll direction. It can be negative if the cell is, for instance,
         on the left of the screen if you're scrolling horizontally.
         */

        let distance: CGFloat
        let itemOffset: CGFloat

        if scrollDirection == .horizontal {
            distance = collectionView.frame.width
            itemOffset = a.center.x - collectionView.contentOffset.x
            a.startOffset = (a.frame.origin.x - collectionView.contentOffset.x) / a.frame.width
            a.endOffset = (a.frame.origin.x - collectionView.contentOffset.x - collectionView.frame.width) / a.frame.width
        } else {
            distance = collectionView.frame.height
            itemOffset = a.center.y - collectionView.contentOffset.y
            a.startOffset = (a.frame.origin.y - collectionView.contentOffset.y) / a.frame.height
            a.endOffset = (a.frame.origin.y - collectionView.contentOffset.y - collectionView.frame.height) / a.frame.height
        }

        a.scrollDirection = scrollDirection
        a.middleOffset = itemOffset / distance - 0.5

        // Cache the contentView since we're going to use it a lot.
        if a.contentView == nil,
            let c = collectionView.cellForItem(at: attributes.indexPath)?.contentView {
            a.contentView = c
        }

        animator?.animate(collectionView: collectionView, attributes: a)

        return a
    }
}
