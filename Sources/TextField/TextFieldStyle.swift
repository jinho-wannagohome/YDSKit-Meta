//
//  TextFieldStyle.swift
//  YDSKit
//
//  Created by Gilwoo Hwang on 2022/06/27.
//

import UIKit

public struct TextFieldStyle: ColorStatemented {

    public enum Size {
        case h64
        case h56
        case h48Small
        case h48Big
        case h44
        case h40

        init(size: CGFloat) {
            switch size {
                case   ...40: self = .h40
                case 41...44: self = .h44
                case 45...48: self = .h48Small
                case 49...56: self = .h56
                case 57...64: self = .h64
                default:      self = .h40
            }
        }

        var rawValue: CGFloat {
            switch self {
                case .h64: return 64
                case .h56: return 56
                case .h48Small, .h48Big: return 48
                case .h44: return 44
                case .h40: return 40
            }
        }

        var iconSize: CGSize {
            switch self {
                case .h64: return CGSize(width: 24, height: 24)
                case .h56: return CGSize(width: 24, height: 24)
                case .h48Big: return CGSize(width: 20, height: 20)
                case .h48Small: return CGSize(width: 20, height: 20)
                case .h44, .h40: return CGSize(width: 20, height: 20)
            }
        }

        var iconPadding: CGFloat { 8 }

        var iconAreaWidth: CGFloat {
            iconPadding * 2 + iconSize.width
        }

        var cornerRadius: CGFloat {
            switch self {
                case .h64: return 12
                case .h56: return 12
                case .h48Big: return 10
                case .h48Small: return 10
                case .h44, .h40: return 10
            }
        }
    }

    public enum ContentsType {
        case text
        case password(secure: Bool)
        case search
        case certified
    }

    public internal(set) var size: Size

    public internal(set) var contentsType: ContentsType = .text

    public internal(set) var color: YDSColor = YDSColor(name: "gray_100_c")

    public internal(set) var firstResponderColor: YDSColor = YDSColor(name: "gray_800_c")

    public internal(set) var variant: ColorStatementedVariant

    public init(
        size: Size = .h40,
        contentsType: ContentsType = .text,
        color: YDSColor? = nil,
        firstResponderColor: YDSColor? = nil,
        variant: ColorStatementedVariant = .outlined
    ) {
        self.size = size
        self.contentsType = contentsType
        self.color = color ?? YDSColor(name: "gray_100_c")
        self.firstResponderColor = firstResponderColor ?? YDSColor(name: "gray_800_c")
        self.variant = variant
    }
}

extension TextFieldStyle {

    var helpTopPadding: CGFloat { 6 }

    var helpLeftPadding: CGFloat {
        switch size {
            case .h64, .h56, .h48Big: return 8
            case .h48Small, .h44, .h40: return 4
        }
    }

    var helpRightPadding: CGFloat {
        switch size {
            case .h64, .h56, .h48Big: return 8
            case .h48Small, .h44, .h40: return 4
        }
    }

    var labelTopPadding: CGFloat {
        switch size {
            case .h64: return 12
            case .h56: return 8
            case .h48Big, .h48Small, .h44, .h40: return 7
        }
    }

    var leftPadding: CGFloat {
        if case .search = contentsType {
            return 8
        }
        switch size {
            case .h64, .h56: return 20
            case .h48Big, .h48Small, .h44, .h40: return 16
        }
    }

    var rightPadding: CGFloat { 16 }

    var bottomPadding: CGFloat {
        switch size {
            case .h64: return 11
            case .h56: return 8
            case .h48Big: return 4
            case .h48Small, .h44, .h40: return 7
        }
    }

    var font: UIFont {
        switch size {
            case .h64: return .systemFont(ofSize: 18)
            case .h56: return .systemFont(ofSize: 18)
            case .h48Big: return .systemFont(ofSize: 16)
            case .h48Small: return .systemFont(ofSize: 14)
            case .h44, .h40: return .systemFont(ofSize: 14)
        }
    }

    var helpFont: UIFont {
        switch size {
            case .h64: return .systemFont(ofSize: 12)
            case .h56: return .systemFont(ofSize: 12)
            case .h48Big: return .systemFont(ofSize: 12)
            case .h48Small: return .systemFont(ofSize: 11)
            case .h44, .h40: return .systemFont(ofSize: 11)
        }
    }

    var labelFont: UIFont {
        switch size {
            case .h64: return .systemFont(ofSize: 12)
            case .h56: return .systemFont(ofSize: 12)
            case .h48Big: return .systemFont(ofSize: 11)
            case .h48Small: return .systemFont(ofSize: 11)
            case .h44, .h40: return .systemFont(ofSize: 11)
        }
    }

    var suffixFont: UIFont {
        switch contentsType {
            case .text, .search:
                return .systemFont(ofSize: 12)
            case .password:
                return .systemFont(ofSize: 12, weight: .bold)
            case .certified:
                return .systemFont(ofSize: 14)
        }
    }
}

extension TextFieldStyle.Size: Equatable {}
