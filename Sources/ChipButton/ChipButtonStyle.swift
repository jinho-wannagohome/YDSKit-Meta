//
//  ChipButtonStyle.swift
//  YDSKit
//
//  Created by 신범철(Shin, Beomcheol) on 2022/02/14.
//

import UIKit

public struct ChipButtonStyle: ColorStatemented {

    public enum Height {
        case h40
        case h36
        case h32
        case h20

        init(height: CGFloat) {
            switch height {
            case   ...20: self = .h20
            case 21...32: self = .h32
            case 33...36: self = .h36
            case 37...  : self = .h40
            default:      self = .h40
            }
        }

        var rawValue: CGFloat {
            switch self {
            case .h40: return 40
            case .h36: return 36
            case .h32: return 32
            case .h20: return 20
            }
        }

        var textSize: CGFloat {
            switch self {
            case .h40, .h36, .h32: return 14
            case .h20: return 10
            }
        }

        var iconSize: CGSize {
            switch self {
            case .h40: return CGSize(width: 16, height: 16)
            case .h36: return CGSize(width: 16, height: 16)
            case .h32: return CGSize(width: 16, height: 16)
            case .h20: return CGSize(width: 12, height: 12)
            }
        }

        var padding: CGFloat {
            switch self {
            case .h40, .h36, .h32: return 12
            case .h20: return 8
            }
        }

        var imagePadding: CGFloat {
            switch self {
            case .h40, .h36, .h32: return 10
            case .h20: return 6
            }
        }
        
        var minimumWidth: CGFloat {
            switch self {
            case .h40: return 48
            case .h36: return 44
            case .h32: return 40
            case .h20: return 28
            }
        }
    }

    public enum ContentsType {
        case textOnly
        case imageLeft(UIImage?)
        case imageRight(UIImage?)
    }

    public internal(set) var height: Height

    public internal(set) var contentsType: ContentsType = .textOnly

    public internal(set) var color: YDSColor = YDSColor(name: "gray_c")

    public internal(set) var selectedColor: YDSColor? = nil

    public var selected: Bool = false

    public internal(set) var variant: ColorStatementedVariant

    public func getWidth(with title: String) -> CGFloat {
        sizeFromTitle(title) + sideSpace.left + sideSpace.right
    }

    let imageInset: CGFloat = 4

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
            return image?.imageAsset?.image(with: traitCollection).resize(to: height.iconSize)
        case .imageLeft(let image):
            return image?.imageAsset?.image(with: traitCollection).resize(to: height.iconSize)
        case .textOnly:
            return nil
        }
    }

    public init(
        height: Height = .h40,
        contentsType: ContentsType = .textOnly,
        color: YDSColor? = nil,
        variant: ColorStatementedVariant = .outlined,
        selected: Bool = false,
        selectedColor: YDSColor? = nil
    ) {
        self.height = height
        self.contentsType = contentsType
        self.color = color ?? YDSColor(name: "gray_c")
        self.variant = variant
        self.selected = selected
        self.selectedColor = selectedColor
    }
}

extension ChipButtonStyle {
    private var sideSpace: (left: CGFloat, right: CGFloat) {
        switch contentsType {
        case .imageLeft: return (height.imagePadding + imageInset + height.iconSize.width, height.padding)
        case .imageRight: return (height.padding, height.imagePadding + imageInset + height.iconSize.width)
        case .textOnly: return (height.padding, height.padding)
        }
    }

    func minimumWidth(withTitleWidth titleWidth: CGFloat) -> CGFloat {
        max(height.minimumWidth, titleWidth + sideSpace.left + sideSpace.right)
    }

    private func sizeFromTitle(_ title: String) -> CGFloat {
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: height.textSize)

        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
    }
}

extension ChipButtonStyle.Height: Equatable {}

extension ChipButtonStyle.ContentsType: Equatable {}
