//
//  ColorStatemented.swift
//  YDSKit
//
//  Created by Masher Shin on 2022/02/19.
//

import UIKit

public enum ColorStatementedVariant {
    case contained
    case outlined
    case text
}

extension ColorStatementedVariant: Equatable {}

protocol ColorStatemented {

    var color: YDSColor { get set }

    var selectedColor: YDSColor? { get set }

    var selected: Bool { get set }

    var variant: ColorStatementedVariant { get set }

}

extension ColorStatemented {

    var selectedColor: YDSColor? {
        get { nil }
        set {}
    }

    var selected: Bool {
        get { false }
        set {}
    }

    private var representColor: YDSColor {
        selected ? (selectedColor ?? color) : color
    }

    var borderColor: UIColor {
        switch variant {
        case .contained, .text:
            return .clear
        case .outlined:
            return representColor
        }
    }

    var disabledBorderColor: UIColor {
        switch variant {
        case .contained, .text:
            return .clear
        case .outlined:
            return YDSColor(name: "gray_100_c")
        }
    }

    private var _contentsColor: YDSColor {
        switch variant {
        case .contained:
            return representColor.contents.contained
        case .outlined:
            return representColor.contents.outlined
        case .text:
            return representColor
        }
    }

    var contentsColor: UIColor {
        _contentsColor
    }

    var disabledContentsColor: UIColor {
        return YDSColor(name: "gray_400_c")
    }

    var backgroundColor: UIColor {
        switch variant {
        case .contained:
            return representColor
        case .outlined, .text:
            return .clear
        }
    }

    var pressedBackgroundColor: UIColor {
        _contentsColor.overlayPressed
    }

    var disabledBackgroundColor: UIColor {
        switch variant {
        case .contained, .outlined:
            return YDSColor(name: "overlay_disabled")
        case .text:
            return .clear
        }
    }

    var isBold: Bool {
        guard case .contained = variant else { return false }
        return representColor.isFoundation
    }
}
