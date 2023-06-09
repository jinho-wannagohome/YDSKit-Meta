//
//  LabelButtonStyle.swift
//  YDSKit
//
//  Created by 신범철(Shin, Beomcheol) on 2022/02/14.
//

import UIKit

public struct LabelButtonStyle: ColorStatemented {

    public enum Size {
        case h56
        case h48
        case h40
        case h36
        case h32
        case h28

        init(size: CGFloat) {
            switch size {
            case   ...28: self = .h28
            case 29...32: self = .h32
            case 33...36: self = .h36
            case 37...40: self = .h40
            case 41...48: self = .h48
            case 49...56: self = .h56
            default:      self = .h28
            }
        }

        var rawValue: CGFloat {
            switch self {
            case .h56: return 56
            case .h48: return 48
            case .h40: return 40
            case .h36: return 36
            case .h32: return 32
            case .h28: return 28
            }
        }

        var font: UIFont {
            switch self {
            case .h56: return .systemFont(ofSize: 18, weight: .bold)
            case .h48: return .systemFont(ofSize: 16, weight: .bold)
            case .h40: return .systemFont(ofSize: 14)
            case .h36: return .systemFont(ofSize: 14)
            case .h32: return .systemFont(ofSize: 12)
            case .h28: return .systemFont(ofSize: 12)
            }
        }

        var iconSize: CGSize {
            switch self {
            case .h56: return CGSize(width: 24, height: 24)
            case .h48: return CGSize(width: 20, height: 20)
            case .h40: return CGSize(width: 18, height: 18)
            case .h36: return CGSize(width: 18, height: 18)
            case .h32: return CGSize(width: 14, height: 14)
            case .h28: return CGSize(width: 14, height: 14)
            }
        }

        var padding: CGFloat {
            switch self {
            case .h56: return 24
            case .h48: return 20
            case .h40: return 16
            case .h36: return 16
            case .h32: return 12
            case .h28: return 10
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
    }

    public enum ContentsType {
        case textOnly
        case imageLeft(UIImage?)
        case imageRight(UIImage?)
    }

    public internal(set) var size: Size

    public internal(set) var contentsType: ContentsType = .textOnly

    public internal(set) var color: YDSColor = YDSColor(name: "primary_a")

    public internal(set) var variant: ColorStatementedVariant

    let imageInset: CGFloat = 2

    var image: UIImage? {
        switch contentsType {
        case .imageRight(let image):
            return image
        case .imageLeft(let image):
            return image
        case .textOnly:
            return nil
        }
    }

    @available(iOS 12.0, *)
    func fittedImage(with traitCollection: UITraitCollection) -> UIImage? {
        switch contentsType {
        case .imageRight(let image):
            return image?.imageAsset?.image(with: traitCollection).resize(to: size.iconSize)
        case .imageLeft(let image):
            return image?.imageAsset?.image(with: traitCollection).resize(to: size.iconSize)
        case .textOnly:
            return nil
        }
    }

    public init(
        size: Size = .h40,
        contentsType: ContentsType = .textOnly,
        color: YDSColor? = nil,
        variant: ColorStatementedVariant = .outlined
    ) {
        self.size = size
        self.contentsType = contentsType
        self.color = color ?? YDSColor(name: "primary_a")
        self.variant = variant
    }
}

extension LabelButtonStyle {
    private var sideSpace: (left: CGFloat, right: CGFloat) {
        switch contentsType {
        case .imageLeft: return (paddingByVariant + imageInset + size.iconSize.width, paddingByVariant)
        case .imageRight: return (paddingByVariant, paddingByVariant + imageInset + size.iconSize.width)
        case .textOnly: return (paddingByVariant, paddingByVariant)
        }
    }

    private var paddingByVariant: CGFloat {
        switch variant {
            case .text:
                return 8
            case .contained, .outlined:
                return size.padding
        }
    }

    func minimumWidth(withTitleWidth titleWidth: CGFloat) -> CGFloat {
        titleWidth + sideSpace.left + sideSpace.right
    }
}

extension LabelButtonStyle.Size: Equatable {}
