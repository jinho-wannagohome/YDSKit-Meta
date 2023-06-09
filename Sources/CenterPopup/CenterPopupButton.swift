//
//  CenterPopupButton.swift
//  
//
//  Created by 윤태민(Yun, Taemin) on 2023/02/27.
//

import Foundation

public struct CenterPopupButton {
    let labelButton: LabelButton
    let dismissCompletion: (() -> Void)?

    public init(title: String?,
                contentType: LabelButtonStyle.ContentsType = .textOnly,
                color: YDSColor? = nil,
                variant: ColorStatementedVariant = .outlined,
                dismissCompletion: (() -> Void)? = nil) {
        let labelButton = LabelButton(title: title)
        labelButton.setupStyle(LabelButtonStyle(size: .h48,
                                                contentsType: contentType,
                                                color: color,
                                                variant: variant))
        self.labelButton = labelButton
        self.dismissCompletion = dismissCompletion
    }
}
