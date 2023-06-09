//
//  YDSLabelButtonContainerView.swift
//  YDSKit
//
//  Created by 임수용(Lim, SuYong) on 2021/11/11.
//

import UIKit

final class YDSLabelButtonContainerView: UIView {
    var buttonHeight: YDSButtonHeight = .h28
    var customPadding: CGFloat? = nil

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init() {
        super.init(frame: .zero)
        initSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var title: String? {
        get { label.text }
        set { label.text = newValue }
    }

    var attributedString: NSAttributedString? {
        get { label.attributedText }
        set { label.attributedText = newValue }
    }

    var textColor: UIColor? {
        get { label.textColor }
        set { label.textColor = newValue }
    }

    func setHeight(_ height: CGFloat) -> YDSButtonHeight {
        buttonHeight = YDSButtonHeight(height: height)
        configure()
        return buttonHeight
    }
}

private extension YDSLabelButtonContainerView {
    func initSubviews() {
        addSubview(label)
        label.makeCenter(to: self)
        label.makeEdge(relatedBy: .greaterThanOrEqual)
    }

    func configure() {
        removePositionConstraints()
        label.makeCenter(to: self)
        label.makeEdge(relatedBy: .greaterThanOrEqual)
        label.font = buttonHeight.font
    }
}
