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

public final class SnapRoulettePickerView: UIView, UICollectionViewDataSource {
    
    // MARK: - Public Properties
    
    /// Delegate that returns the index of the current central element of the collection.
    public var snapPickerViewDelegate: SnapPickerViewDelegate?
    /// The range of numbers to select in the picker.
    public var range: ClosedRange<Int> = 50...250 {
        didSet {
            numbers = [Int](range)
        }
    }
    /// Step with which the numbers on the roulette wheel will go.
    public var step: Int = 5
    /// Accent color of lines in roulette.
    public var accentColor: UIColor = .init(
        red: 55 / 255,
        green: 98 / 255,
        blue: 234 / 255,
        alpha: 1.0
    )
    /// Width of roulette lines.
    public var lineWidth: CGFloat = 4.0
    /// The spacing between the roulette lines and the label which displays the pitch of the numbers.
    public var spacingBetweenLineAndStepLabel: CGFloat = 6.0
    /// The font of the label that displays the pitch of the numbers in the roulette wheel.
    public var stepSubtitleLabelFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    /// The color of the text in the label which displays the step of numbers in the roulette wheel.
    public var stepSubtitleLabelTextColor: UIColor = .systemGray
    /// The main collection of roulette.
    public lazy var collectionView = SnapCollectionView()
    
    // MARK: - Private Properties
    
    private lazy var numbers = [Int](range)
    private lazy var centerLineView = UIView()
    private lazy var centerCircleView = UIView()
    
    // MARK: - Initializers
    
    public init() {
        super.init(frame: .zero)
        setupCollectionView()
        setupCenterIndicatorLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        switch collectionView.scrollDirection {
        case .horizontal:
            collectionView.itemSize = CGSize(width: lineWidth, height: bounds.height)
            centerLineView.bounds.size = CGSize(
                width: lineWidth,
                height: collectionView.itemSize.height * 0.8 - spacingBetweenLineAndStepLabel
            )
            centerLineView.center.x = collectionView.center.x
            centerLineView.frame.origin.y = .zero
            centerCircleView.center = centerLineView.center
        default:
            collectionView.itemSize = CGSize(width: bounds.width, height: lineWidth)
            centerLineView.bounds.size = CGSize(
                width: collectionView.itemSize.width * 0.7 - spacingBetweenLineAndStepLabel,
                height: lineWidth
            )
            centerLineView.center.y = collectionView.center.y
            centerLineView.frame.origin.x = .zero
            centerCircleView.center = centerLineView.center
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        numbers.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: RouletteCollectionViewCell.self),
            for: indexPath
        ) as? RouletteCollectionViewCell else { return UICollectionViewCell() }
        cell.isStepDivider = numbers[indexPath.row] % step == 0
        cell.stepSubtitleLabel.text = String(numbers[indexPath.row])
        cell.stepSubtitleLabel.font = stepSubtitleLabelFont
        cell.stepSubtitleLabel.textColor = stepSubtitleLabelTextColor
        cell.lineWidth = lineWidth * 0.75
        cell.spacingBetweenLineAndStepLabel = spacingBetweenLineAndStepLabel
        cell.direction = self.collectionView.scrollDirection
        cell.lineView.backgroundColor = accentColor.withAlphaComponent(0.35)
        return cell
    }
    
    // MARK: - Private Methods
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.pickerDelegate = self
        collectionView.register(
            RouletteCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: RouletteCollectionViewCell.self)
        )
        addSubview(collectionView)
    }
    
    private func setupCenterIndicatorLine() {
        centerLineView.backgroundColor = accentColor
        centerLineView.clipsToBounds = true
        centerLineView.layer.cornerRadius = lineWidth / 2
        centerCircleView.backgroundColor = accentColor
        centerCircleView.clipsToBounds = true
        centerCircleView.bounds.size = CGSize(width: lineWidth * 4, height: lineWidth * 4)
        centerCircleView.layer.cornerRadius = centerCircleView.bounds.height / 2
        addSubview(centerLineView)
        addSubview(centerCircleView)
    }
}

// MARK: - SnapCollectionViewDelegate

extension SnapRoulettePickerView: SnapCollectionViewDelegate {
    public func didSelectItem(at index: Int) {
        guard index < numbers.count else { return }
        snapPickerViewDelegate?.didSelectNumber(numbers[index], pickerView: self)
    }
}
