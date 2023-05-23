//
//  ViewController.swift
//  SnapCollection
//
//  Created by Иван Изюмкин on 23.05.2023.
//

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
            origin: .init(x: 0, y: 180),
            size: .init(width: view.frame.size.width, height: 76)
        )
        horizontallyRoulettePickerView.scrollDirection = .horizontal
        horizontallyRoulettePickerView.spacing = 14
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
