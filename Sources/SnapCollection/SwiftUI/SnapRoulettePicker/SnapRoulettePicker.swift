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
public struct SnapRoulettePicker: UIViewRepresentable {
    
    public class Coordinator: NSObject, SnapCollectionViewDelegate {

        private let picker: SnapRoulettePicker
        
        // MARK: - Initializers
        
        init(_ picker: SnapRoulettePicker) {
            self.picker = picker
        }
        
        // MARK: - SnapCollectionViewDelegate
        
        public func didSelectItem(at index: Int) {
            picker.currentSelectedCellIndex = index
        }
    }
    
    // MARK: - Public Properties
    
    let range: ClosedRange<Int>
    let step: Int
    let scrollDirection: UICollectionView.ScrollDirection
    let accentColor: UIColor?
    let lineWidth: CGFloat?
    let spacingBetweenLineAndStepLabel: CGFloat?
    let stepSubtitleLabelFont: UIFont?
    let stepSubtitleLabelTextColor: UIColor?
    let spacing: CGFloat?
    let feedbackIntensity: CGFloat?
    let feedBackGeneratorStyle: UIImpactFeedbackGenerator.FeedbackStyle?
    
    @Binding var currentSelectedCellIndex: Int
    
    // MARK: - Initializers
    
    public init(
        range: ClosedRange<Int>,
        step: Int,
        scrollDirection: UICollectionView.ScrollDirection,
        currentSelectedCellIndex: Binding<Int>,
        accentColor: UIColor? = nil,
        lineWidth: CGFloat? = nil,
        spacingBetweenLineAndStepLabel: CGFloat? = nil,
        stepSubtitleLabelFont: UIFont? = nil,
        stepSubtitleLabelTextColor: UIColor? = nil,
        spacing: CGFloat? = nil,
        feedbackIntensity: CGFloat? = nil,
        feedBackGeneratorStyle: UIImpactFeedbackGenerator.FeedbackStyle? = nil
    ) {
        self.range = range
        self.step = step
        self.scrollDirection = scrollDirection
        self.accentColor = accentColor
        self.lineWidth = lineWidth
        self.spacingBetweenLineAndStepLabel = spacingBetweenLineAndStepLabel
        self.stepSubtitleLabelFont = stepSubtitleLabelFont
        self.stepSubtitleLabelTextColor = stepSubtitleLabelTextColor
        self.spacing = spacing
        self.feedbackIntensity = feedbackIntensity
        self.feedBackGeneratorStyle = feedBackGeneratorStyle
        self._currentSelectedCellIndex = currentSelectedCellIndex
    }
    
    // MARK: - Public Methods
    
    public func makeUIView(context: Context) -> SnapRoulettePickerView {
        let pickerView = SnapRoulettePickerView()
        pickerView.range = range
        pickerView.collectionView.scrollDirection = scrollDirection
        pickerView.collectionView.pickerDelegate = context.coordinator
        if let spacing { pickerView.collectionView.spacing = spacing }
        if let accentColor { pickerView.accentColor = accentColor }
        if let lineWidth { pickerView.lineWidth = lineWidth }
        if let spacingBetweenLineAndStepLabel { pickerView.spacingBetweenLineAndStepLabel = spacingBetweenLineAndStepLabel }
        if let stepSubtitleLabelTextColor { pickerView.stepSubtitleLabelTextColor = stepSubtitleLabelTextColor }
        if let feedbackIntensity { pickerView.collectionView.feedbackIntensity = feedbackIntensity }
        if let feedBackGeneratorStyle { pickerView.collectionView.feedBackGeneratorStyle = feedBackGeneratorStyle }
        return pickerView
    }
    
    public func updateUIView(_ uiView: SnapRoulettePickerView, context: Context) { }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
