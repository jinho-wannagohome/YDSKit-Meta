//
//  YDSButtonHeight.swift
//  YDSKit
//
//  Created by 임수용(Lim, SuYong) on 2021/11/15.
//
import UIKit

enum YDSButtonPaddingStyle {
    case normal
    case custom(CGFloat)
}

enum YDSButtonHeight {
    case h56
    case h48
    case h40
    case h36
    case h32
    case h28

    init(height: CGFloat) {
        switch height {
            case _ where height <= 28: self = .h28
            case _ where height <= 32: self = .h32
            case _ where height <= 36: self = .h36
            case _ where height <= 40: self = .h40
            case _ where height <= 48: self = .h48
            case _ where height > 48: self = .h56
            default:
                self = .h28
        }
    }

    var cornerRadius: CGFloat {
        switch self {
            case .h56: return 12
            case .h48: return 10
            case .h40: return 8
            case .h36: return 8
            case .h32: return 6
            case .h28: return 6
        }
    }

    var minimumSidePadding: CGFloat {
        switch self {
            case .h56: return 24
            case .h48: return 20
            case .h40: return 16
            case .h36: return 16
            case .h32: return 12
            case .h28: return 10
        }
    }

    var font: UIFont {
        switch self {
            case .h56:
                return .systemFont(ofSize: 18, weight: .bold)
            case .h48:
                return .systemFont(ofSize: 16, weight: .bold)
            case .h40:
                return .systemFont(ofSize: 14)
            case .h36:
                return .systemFont(ofSize: 14)
            case .h32:
                return .systemFont(ofSize: 12)
            case .h28:
                return .systemFont(ofSize: 12)
        }
    }
}
