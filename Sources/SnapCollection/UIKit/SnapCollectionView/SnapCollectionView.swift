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

public protocol SnapCollectionViewDelegate: AnyObject {
    func didSelectItem(at index: Int)
}

public class SnapCollectionView: UICollectionView {
    
    // MARK: - Public Properties
    
    /// The scroll direction of the grid.
    public var scrollDirection: ScrollDirection = .horizontal {
        didSet {
            (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = scrollDirection
        }
    }
    /// The default size to use for cells.
    public var itemSize: CGSize = .zero {
        didSet {
            (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = itemSize
        }
    }
    /// The spacing to use between items.
    public var spacing: CGFloat = .zero {
        didSet {
            (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing = spacing
        }
    }
    /// The intensity of tactile feedback during the scroll collection.
    public var feedbackIntensity: CGFloat = 0.7
    /// Feedback generator style. To turn off, set `nil` to this parameter.
    ///
    /// The default value of this property is `.light`.
    public var feedBackGeneratorStyle: UIImpactFeedbackGenerator.FeedbackStyle? = .light {
        didSet {
            guard let feedBackGeneratorStyle = feedBackGeneratorStyle else {
                feedBackGenerator = nil
                return
            }
            feedBackGenerator = UIImpactFeedbackGenerator(style: feedBackGeneratorStyle)
        }
    }
    /// Delegate that returns the index of the current central element of the collection.
    public weak var pickerDelegate: SnapCollectionViewDelegate?
    
    // MARK: - Private Properties
    
    private var feedBackGenerator: UIImpactFeedbackGenerator? = {
        if #available(iOS 13.0, *) {
            return UIImpactFeedbackGenerator(style: .soft)
        } else {
            return UIImpactFeedbackGenerator(style: .medium)
        }
    }()
    
    private var isScrollingAnimationActive = false
    private var currentSelectedCellIndex = 0 {
        didSet {
            pickerDelegate?.didSelectItem(at: currentSelectedCellIndex)
        }
    }
    
    // MARK: - Initializers
    
    public init() {
        super.init(frame: .zero, collectionViewLayout: SnapCollectionViewLayout())
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let currentView = super.hitTest(point, with: event)
        return isScrollingAnimationActive ? (currentView === self ? nil : currentView) : currentView
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        switch scrollDirection {
        case .horizontal:
            let sideInset = (frame.width - itemSize.width) / 2
            (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset.left = sideInset
            (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset.right = sideInset
        default:
            let sideInset = (frame.height - itemSize.height) / 2
            (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset.top = sideInset
            (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset.bottom = sideInset
        }
    }
    
    // MARK: - Private Methods
    
    private func processingFeedback() {
        let center = CGPoint(
            x: contentOffset.x + frame.width / 2,
            y: contentOffset.y + frame.height / 2
        )
        let index = indexPathForItem(at: center)?.row
        guard let index, currentSelectedCellIndex != index else { return }
        currentSelectedCellIndex = index
        if #available(iOS 13.0, *) {
            feedBackGenerator?.impactOccurred(intensity: feedbackIntensity)
        } else {
            feedBackGenerator?.impactOccurred()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension SnapCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: scrollDirection.center, animated: true)
        isScrollingAnimationActive = true
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        processingFeedback()
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrollingAnimationActive = false
    }
}

private extension UICollectionView.ScrollDirection {
    var center: UICollectionView.ScrollPosition {
        switch self {
        case .vertical:
            return .centeredVertically
        default:
            return .centeredHorizontally
        }
    }
}
