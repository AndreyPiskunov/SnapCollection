// MIT License
//
// Copyright (c) 2023 Ivan Izyumkin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

final class SnapCollectionViewLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionViewSize = collectionView?.bounds.size else { return proposedContentOffset }
        
        let proposedContentRect = CGRect(origin: proposedContentOffset, size: collectionViewSize)
        let proposedContentOffsetCenter = CGPoint(
            x: proposedContentOffset.x + collectionViewSize.width / 2,
            y: proposedContentOffset.y + collectionViewSize.height / 2
        )
        let proposedVisibleCellsAttributes = (layoutAttributesForElements(in: proposedContentRect) ?? [])
        
        guard let centerCellAttributes = proposedVisibleCellsAttributes.min(by: { lhs, rhs in
            let lhsCellCenter = CGPoint(
                x: abs(lhs.center.x - proposedContentOffsetCenter.x),
                y: abs(lhs.center.y - proposedContentOffsetCenter.y)
            )
            let rhsCellCenter = CGPoint(
                x: abs(rhs.center.x - proposedContentOffsetCenter.x),
                y: abs(rhs.center.y - proposedContentOffsetCenter.y)
            )
            return lhsCellCenter.x < rhsCellCenter.x || lhsCellCenter.y < rhsCellCenter.y
        }) else { return proposedContentOffset }
        return CGPoint(
            x: centerCellAttributes.center.x - collectionViewSize.width * 0.5,
            y: centerCellAttributes.center.y - collectionViewSize.height * 0.5
        )
    }
}
