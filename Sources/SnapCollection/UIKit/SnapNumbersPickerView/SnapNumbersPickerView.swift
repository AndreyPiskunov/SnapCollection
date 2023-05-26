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

public protocol SnapPickerViewDelegate: AnyObject {
    func didSelectNumber(_ number: Int, pickerView: UIView)
}

public class SnapNumbersPickerView: SnapCollectionView {
    
    // MARK: - Types
    
    public enum AnimationType {
        case onlyCenter
        case circle
    }
    
    public struct AnimationSettings {
        let type: AnimationType
        
        let maxScale: CGFloat
        let minScale: CGFloat
        
        let maxAlpha: CGFloat
        let minAlpha: CGFloat
        
        var scaleDifference: CGFloat {
            maxScale - minScale
        }
        
        var alphaDifference: CGFloat {
            maxAlpha - minAlpha
        }
        
        public init(
            type: AnimationType,
            maxScale: CGFloat,
            minScale: CGFloat,
            maxAlpha: CGFloat,
            minAlpha: CGFloat
        ) {
            self.type = type
            self.maxScale = maxScale
            self.minScale = minScale
            self.maxAlpha = maxAlpha
            self.minAlpha = minAlpha
        }
    }
    
    // MARK: - Public Properties
    
    public weak var snapPickerViewDelegate: SnapPickerViewDelegate?
    
    public var range: ClosedRange<Int> = 50...250 {
        didSet {
            numbers = [Int](range)
        }
    }
    
    public var animationSettings: AnimationSettings?
    
    public var numbersFont: UIFont? = UIFont.systemFont(ofSize: 52, weight: .bold)
    public var numbersAccentColor: UIColor = .init(
        red: 55 / 255,
        green: 98 / 255,
        blue: 234 / 255,
        alpha: 1.0
    )
    
    // MARK: - Private Properties
    
    private lazy var numbers = [Int](range)
    
    // MARK: - Initializers
    
    public override init() {
        super.init()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        processingAnimation()
    }
    
    // MARK: - UICollectionViewDelegate
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        processingAnimation()
    }
    
    // MARK: - Private Methods
    
    private func setupCollectionView() {
        backgroundColor = .clear
        dataSource = self
        pickerDelegate = self
        register(
            NumberCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: NumberCollectionViewCell.self)
        )
    }
    
    private func processingAnimation() {
        guard let animationSettings else { return }
        let maxCenterDistance: CGPoint = {
            switch animationSettings.type {
            case .onlyCenter:
                return CGPoint(
                    x: itemSize.width + spacing,
                    y: itemSize.height + spacing
                )
            case .circle:
                return CGPoint(
                    x: bounds.width / 2.0,
                    y: bounds.height / 2.0
                )
            }
        }()
        
        for cell in visibleCells {
            let cellPositionFromCenter: CGPoint = {
                CGPoint(
                    x: abs(bounds.width / 2 - (cell.frame.midX - contentOffset.x)),
                    y: abs(bounds.height / 2 - (cell.frame.midY - contentOffset.y))
                )
            }()
            let scale = {
                switch scrollDirection {
                case .horizontal:
                    guard cellPositionFromCenter.x < maxCenterDistance.x else { return 0.0 }
                    return (100.0 - (cellPositionFromCenter.x * 100 / maxCenterDistance.x)) / 100
                default:
                    guard cellPositionFromCenter.y < maxCenterDistance.y else { return 0.0 }
                    return (100.0 - (cellPositionFromCenter.y * 100 / maxCenterDistance.y)) / 100
                }
            }()
            let finalScale = animationSettings.minScale + animationSettings.scaleDifference * scale
            cell.transform = CGAffineTransformMakeScale(finalScale, finalScale)
            cell.alpha = animationSettings.minAlpha + animationSettings.alphaDifference * scale
        }
    }
}

// MARK: - SnapCollectionViewDelegate

extension SnapNumbersPickerView: SnapCollectionViewDelegate {
    public func didSelectItem(at index: Int) {
        guard index < numbers.count else { return }
        snapPickerViewDelegate?.didSelectNumber(numbers[index], pickerView: self)
    }
}


// MARK: - UICollectionViewDataSource

extension SnapNumbersPickerView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numbers.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: NumberCollectionViewCell.self),
            for: indexPath
        ) as? NumberCollectionViewCell else { return UICollectionViewCell() }
        cell.textLabel.text = String(numbers[indexPath.row])
        cell.textLabel.font = numbersFont
        cell.textLabel.textColor = numbersAccentColor
        return cell
    }
}
