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

final class RouletteCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    public var stepSubtitleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.textAlignment = .center
        return label
    }()
    
    public var lineView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    public var isStepDivider = false {
        didSet {
            stepSubtitleLabel.isHidden = !isStepDivider
        }
    }
    
    public var lineWidth: CGFloat = 3
    public var spacingBetweenLineAndStepLabel: CGFloat = .zero
    public var direction: UICollectionView.ScrollDirection = .horizontal
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isStepDivider = false
        stepSubtitleLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch direction {
        case .horizontal:
            stepSubtitleLabel.bounds.size = CGSize(
                width: stepSubtitleLabel.intrinsicContentSize.width,
                height: contentView.bounds.height * 0.2
            )
            stepSubtitleLabel.center.x = contentView.center.x
            stepSubtitleLabel.frame.origin.y = contentView.bounds.height - stepSubtitleLabel.bounds.height
            
            let lineMaxHeight = stepSubtitleLabel.frame.origin.y - spacingBetweenLineAndStepLabel
            let lineSize = CGSize(
                width: lineWidth,
                height: lineMaxHeight * (isStepDivider ? 1.0 : 0.42)
            )
            lineView.bounds.size = lineSize
            lineView.center.x = contentView.center.x
            lineView.frame.origin.y = (lineMaxHeight - lineSize.height) / 2
            lineView.layer.cornerRadius = lineSize.width / 2
        default:
            stepSubtitleLabel.bounds.size = CGSize(
                width: contentView.bounds.width * 0.3,
                height: contentView.bounds.width * 0.2
            )
            stepSubtitleLabel.center.y = contentView.center.y
            stepSubtitleLabel.frame.origin.x = contentView.bounds.width - stepSubtitleLabel.bounds.width
            
            let lineMaxWidth = stepSubtitleLabel.frame.origin.x - spacingBetweenLineAndStepLabel
            let lineSize = CGSize(
                width: lineMaxWidth * (isStepDivider ? 1.0 : 0.42),
                height: lineWidth
            )
            lineView.bounds.size = lineSize
            lineView.center.y = contentView.center.y
            lineView.frame.origin.x = (lineMaxWidth - lineSize.width) / 2
            lineView.layer.cornerRadius = lineSize.height / 2
        }
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        contentView.addSubview(lineView)
        contentView.addSubview(stepSubtitleLabel)
    }
}
