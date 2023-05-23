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

public final class SnapNumbersPickerView: SnapCollectionView, UICollectionViewDataSource {
    
    // MARK: - Public Properties
    
    public weak var snapPickerViewDelegate: SnapPickerViewDelegate?
    
    public var range: ClosedRange<Int> = 50...250 {
        didSet {
            numbers = [Int](range)
        }
    }
    public var numbersFont: UIFont = UIFont.systemFont(ofSize: 52, weight: .bold)
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
    
    // MARK: - UICollectionViewDataSource
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
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
    
    // MARK: - Private Methods
    
    private func setupCollectionView() {
        dataSource = self
        pickerDelegate = self
        register(
            NumberCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: NumberCollectionViewCell.self)
        )
    }
}

// MARK: - SnapCollectionViewDelegate

extension SnapNumbersPickerView: SnapCollectionViewDelegate {
    public func didSelectItem(at index: Int) {
        guard index < numbers.count else { return }
        snapPickerViewDelegate?.didSelectNumber(numbers[index], pickerView: self)
    }
}
