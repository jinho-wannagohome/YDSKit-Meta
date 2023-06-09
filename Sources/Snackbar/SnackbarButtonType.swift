//
//  SnackbarButtonType.swift
//
//
//  Created by 윤태민(Yun, Taemin) on 2022/12/21.
//

import Foundation

public enum SnackbarButtonType {
    case image(name: String)
    case text(String)

    var rightMarginInSuperView: CGFloat {
        switch self {
        case .image:    return 12.0
        case .text:     return 16.0
        }
    }
}
