//
//  YDSButtonStateOverlayView.swift
//  YDSKit
//
//  Created by 임수용(Lim, SuYong) on 2021/11/12.
//

import UIKit

public enum YDSButtonState {
    case enabled
    case highlighted
    case disabled

    func overlayColorAlpha(isWhite: Bool) -> CGFloat {
        switch self {
            case .enabled:
                return 0
            case .highlighted:
                return isWhite ? 0.2 : 0.1
            case .disabled:
                return 0.08
        }
    }
}

final class YDSButtonStateOverlayView: UIView {
    private(set) var contentColor: UIColor?
    private(set) var state: YDSButtonState = .enabled
    private(set) var borderColor: UIColor = .clear

    init() {
        super.init(frame: .zero)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(state: YDSButtonState,
             contentColor: UIColor?,
             borderColor: UIColor) {
        self.state = state
        self.contentColor = contentColor
        self.borderColor = borderColor
        configure()
    }

    func configure() {
        guard state != .disabled else {
            setDisabled()
            return
        }
        layer.borderWidth = 0
        let isWhite = contentColor?.isWhite ?? false
        let alpha = state.overlayColorAlpha(isWhite: isWhite)
        backgroundColor = contentColor?.withAlphaComponent(alpha)
    }

    func setDisabled() {
        backgroundColor = YDSLabelButton.appearance.disabledOverlayColor
        let hasBorder = borderColor != .clear
        if hasBorder {
            layer.borderColor = YDSLabelButton.appearance.disabledBorderColor.cgColor
            layer.borderWidth = 1
        } else {
            layer.borderWidth = 0
        }
    }
}
