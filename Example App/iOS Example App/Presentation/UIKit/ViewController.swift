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
import SnapCollection

class ViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var horizontallyNumbersPickerView = SnapNumbersPickerView()
    private lazy var horizontallyRoulettePickerView = SnapRoulettePickerView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        horizontallyNumbersPickerView.frame = CGRect(
            origin: .init(x: 0, y: 80),
            size: .init(width: view.frame.size.width, height: 76)
        )
        horizontallyNumbersPickerView.itemSize = CGSize(width: 73, height: 76)
        horizontallyNumbersPickerView.scrollDirection = .horizontal
        horizontallyNumbersPickerView.spacing = 10
        horizontallyNumbersPickerView.animationSettings = .init(
            type: .onlyCenter,
            maxScale: 1.4,
            minScale: 1.0,
            maxAlpha: 1.0,
            minAlpha: 0.35
        )
        horizontallyNumbersPickerView.snapPickerViewDelegate = self
        view.addSubview(horizontallyNumbersPickerView)
        
        horizontallyRoulettePickerView.frame = CGRect(
            origin: .init(x: 0, y: horizontallyNumbersPickerView.frame.maxY + 10),
            size: .init(width: view.frame.size.width, height: 76)
        )
        horizontallyRoulettePickerView.collectionView.scrollDirection = .horizontal
        horizontallyRoulettePickerView.collectionView.spacing = 14
        horizontallyRoulettePickerView.snapPickerViewDelegate = self
        view.addSubview(horizontallyRoulettePickerView)
    }
}

// MARK: - SnapPickerViewDelegate

extension ViewController: SnapPickerViewDelegate {
    func didSelectNumber(_ number: Int, pickerView: UIView) {
        switch pickerView {
        case horizontallyNumbersPickerView:
            print("horizontallyNumbersPickerView:", number)
        case horizontallyRoulettePickerView:
            print("horizontallyRoulettePickerView:", number)
        default:
            break
        }
    }
}
