//
//  ButtomSheetType.swift
//  YDSKit
//
//  Created by Masher Shin on 2022/07/16.
//

import CoreGraphics

public enum ButtomSheetType {

    public typealias Button = (title: String, action: () -> Void)
    public typealias ButtonsType = (button0: Button, button1: Button?)

    /// Header + Body + Footer
    case standard(title: String?, buttons: ButtonsType)
    /// Header + Body
    case title(String?)
    /// Header + Footer
    case button(title: String?, buttons: ButtonsType)
    /// Body + Footer
    case noneTitle(ButtonsType)
    /// Body
    case contents

    var title: String? {
        switch self {
        case .standard(let title, _), .title(let title), .button(let title, _):
            return title
        case .noneTitle(_), .contents:
            return nil
        }
    }

    var isHiddenHeader: Bool {
        switch self {
        case .noneTitle(_), .contents: return true
        case .standard(_, _), .title(_), .button(_, _): return false
        }
    }

    var isHiddenFooter: Bool {
        switch self {
        case .title(_), .contents: return true
        case .standard(_, _), .button(_, _), .noneTitle(_): return false
        }
    }

    enum CTAType {
        case twoButton(action0: Button, action1: Button)
        case oneButton(Button)
        case none

        init(button: ButtonsType?) {
            guard let button = button else {
                self = .none
                return
            }
            if let button2 = button.button1 {
                self = .twoButton(action0: button.button0, action1: button2)
            } else {
                self = .oneButton(button.button0)
            }
        }

        var titleOne: String? {
            switch self {
            case .twoButton(let button0, _), .oneButton(let button0):
                return button0.title
            case .none:
                return nil
            }
        }

        var titleTwo: String? {
            switch self {
            case .twoButton(_, let button1):
                return button1.title
            case .oneButton(_), .none:
                return nil
            }
        }

        var actionOne: (() -> Void)? {
            switch self {
            case .twoButton(let button0, _), .oneButton(let button0):
                return button0.action
            case .none:
                return nil
            }
        }

        var actionTwo: (() -> Void)? {
            switch self {
            case .twoButton(_, let button1):
                return button1.action
            case .oneButton(_), .none:
                return nil
            }
        }

        var isOneButton: Bool {
            switch self {
            case .oneButton(_): return true
            case .twoButton(_, _), .none: return false
            }
        }
    }

    var ctaType: CTAType {
        switch self {
        case .standard(_, let type), .button(_, let type), .noneTitle(let type):
            return CTAType(button: type)
        case .title(_), .contents:
            return .none
        }
    }

    var headerHeight: CGFloat {
        isHiddenHeader ? 24 : 64
    }

    var contentsBottom: CGFloat {
        isHiddenFooter ? 0 : 24
    }

    var isActiveFooterHeight: Bool {
        isHiddenFooter
    }

    var footerHeight: CGFloat {
        isHiddenFooter ? 0 : 80
    }

    static let defaultContentsHeight = CGFloat(70)
    static let contentsBottomMargin = CGFloat(24)

    var minimumContentsHeight: CGFloat {
        switch self {
        case .standard(_, _), .title(_), .noneTitle(_), .contents:
            return Self.defaultContentsHeight + Self.contentsBottomMargin
        case .button(_, _):
            return 0
        }
    }

    var minimumHeight: CGFloat {
        switch self {
        case .standard(_, _), .title(_), .noneTitle(_), .contents:
            return headerHeight + minimumContentsHeight + footerHeight
        case .button(_, _):
            return headerHeight + footerHeight
        }
    }

    func maximumHeight(with contentsHeight: CGFloat) -> CGFloat {
        switch self {
        case .standard(_, _), .title(_), .noneTitle(_), .contents:
            let bodyHeight = max(contentsHeight + Self.contentsBottomMargin, minimumContentsHeight)
            return headerHeight + bodyHeight + footerHeight
        case .button(_, _):
            return headerHeight + footerHeight
        }
    }
}
