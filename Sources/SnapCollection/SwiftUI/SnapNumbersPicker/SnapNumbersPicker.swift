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

import SwiftUI

@available(iOS 13.0, *)
public struct SnapNumbersPicker: UIViewRepresentable {
    
    public class Coordinator: NSObject, SnapCollectionViewDelegate {

        private let picker: SnapNumbersPicker
        
        // MARK: - Initializers
        
        init(_ picker: SnapNumbersPicker) {
            self.picker = picker
        }
        
        // MARK: - SnapCollectionViewDelegate
        
        public func didSelectItem(at index: Int) {
            picker.currentSelectedCellIndex = index
        }
    }
    
    // MARK: - Public Properties
    
    let range: ClosedRange<Int>
    let itemSize: CGSize
    let scrollDirection: UICollectionView.ScrollDirection
    let animationSettings: SnapNumbersPickerView.AnimationSettings?
    let numbersFont: UIFont?
    let numbersAccentColor: UIColor?
    let spacing: CGFloat?
    let feedbackIntensity: CGFloat?
    let feedBackGeneratorStyle: UIImpactFeedbackGenerator.FeedbackStyle?
    
    @Binding var currentSelectedCellIndex: Int
    
    // MARK: - Initializers
    
    public init(
        range: ClosedRange<Int>,
        itemSize: CGSize,
        scrollDirection: UICollectionView.ScrollDirection,
        currentSelectedCellIndex: Binding<Int>,
        animationSettings: SnapNumbersPickerView.AnimationSettings? = nil,
        numbersFont: UIFont? = nil,
        numbersAccentColor: UIColor? = nil,
        spacing: CGFloat? = nil,
        feedbackIntensity: CGFloat? = nil,
        feedBackGeneratorStyle: UIImpactFeedbackGenerator.FeedbackStyle? = nil
    ) {
        self.range = range
        self.itemSize = itemSize
        self.scrollDirection = scrollDirection
        self.animationSettings = animationSettings
        self.numbersFont = numbersFont
        self.numbersAccentColor = numbersAccentColor
        self.spacing = spacing
        self.feedbackIntensity = feedbackIntensity
        self.feedBackGeneratorStyle = feedBackGeneratorStyle
        self._currentSelectedCellIndex = currentSelectedCellIndex
    }
    
    // MARK: - Public Methods
    
    public func makeUIView(context: Context) -> SnapNumbersPickerView {
        let collectionView = SnapNumbersPickerView()
        collectionView.range = range
        collectionView.itemSize = itemSize
        collectionView.scrollDirection = scrollDirection
        collectionView.pickerDelegate = context.coordinator
        if let animationSettings { collectionView.animationSettings = animationSettings }
        if let numbersFont { collectionView.numbersFont = numbersFont }
        if let numbersAccentColor { collectionView.numbersAccentColor = numbersAccentColor }
        if let spacing { collectionView.spacing = spacing }
        if let feedbackIntensity { collectionView.feedbackIntensity = feedbackIntensity }
        if let feedBackGeneratorStyle { collectionView.feedBackGeneratorStyle = feedBackGeneratorStyle }
        return collectionView
    }
    
    public func updateUIView(_ uiView: SnapNumbersPickerView, context: Context) { }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
