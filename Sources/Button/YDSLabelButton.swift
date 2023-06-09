//
//  YDSLabelButton.swift
//  YDSKit
//
//  Created by 임수용(Lim, SuYong) on 2021/11/11.
//

import UIKit
@available(*, deprecated, message: "Use LabelButton instead.")
public class YDSLabelButton: UIControl {
    static public var appearance = YDSLabelButtonConfig()

    @IBInspectable public var customPadding: CGFloat = 0 {
        didSet {
            containerView.customPadding = customPadding > 0 ? customPadding : nil
        }
    }

    @IBInspectable public var title: String? {
        get { containerView.title }
        set { containerView.title = newValue }
    }

    @IBInspectable public var textColor: UIColor? {
        didSet {
            configureState()
        }
    }

    @IBInspectable public var borderColor: UIColor = .clear {
        didSet {
            configureBorderColor()
        }
    }

    public override var backgroundColor: UIColor? {
        get { backgroundView.backgroundColor }
        set {
            backgroundView.backgroundColor = newValue
            configureState()
        }
    }

    public override var isEnabled: Bool {
        didSet { configureState() }
    }

    private lazy var containerView: YDSLabelButtonContainerView = {
        let view = YDSLabelButtonContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stateOverlayView: YDSButtonStateOverlayView = {
        let view = YDSButtonStateOverlayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public override func awakeFromNib() {
        super.awakeFromNib()

        initSubviews()
        super.backgroundColor = .clear
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        configureCornerRadius()
        configureBorderColor()
    }

    public var attributedString: NSAttributedString? {
        get { containerView.attributedString }
        set { containerView.attributedString = newValue }
    }
}

private extension YDSLabelButton {
    func initSubviews() {
        clipsToBounds = true

        addSubview(backgroundView)
        backgroundView.makeEdge()

        addSubview(containerView)
        containerView.makeEdge()

        addSubview(stateOverlayView)
        stateOverlayView.makeEdge()
    }

    func configureState() {
        let state: YDSButtonState

        containerView.textColor = contentColor
        containerView.backgroundColor = isEnabled ? backgroundColor : .clear

        backgroundView.isHidden = isEnabled == false

        state = isEnabled ? .enabled : .disabled
        stateOverlayView.set(state: state, contentColor: contentColor, borderColor: borderColor)
    }

    var contentColor: UIColor? {
        return isEnabled ? textColor : YDSLabelButton.appearance.disabledTextColor
    }

    func configureCornerRadius() {
        let height = containerView.setHeight(self.bounds.height)
        layer.cornerRadius = height.cornerRadius
        backgroundView.layer.cornerRadius = height.cornerRadius
        stateOverlayView.layer.cornerRadius = height.cornerRadius
    }

    func configureBorderColor() {
        let hasBorder = borderColor != .clear
        backgroundView.layer.borderColor = borderColor.cgColor
        backgroundView.layer.borderWidth = hasBorder ? 1 : 0
    }
}

extension YDSLabelButton {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        stateOverlayView.set(state: .highlighted, contentColor: contentColor, borderColor: borderColor)
        sendActions(for: .touchDown)
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        stateOverlayView.set(state: .enabled, contentColor: contentColor, borderColor: borderColor)
        sendActions(for: .touchCancel)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        stateOverlayView.set(state: .enabled, contentColor: contentColor, borderColor: borderColor)
        if let touchLocation = touches.first?.location(in: self),
           point(inside: touchLocation, with: event) {
            sendActions(for: .touchUpInside)
        }
    }
}
