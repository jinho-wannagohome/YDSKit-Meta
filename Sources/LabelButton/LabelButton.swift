//
//  LabelButton.swift
//  YDSKit
//
//  Created by 신범철(Shin, Beomcheol) on 2022/02/16.
//

import UIKit

public class LabelButton: UIButton {

    private let defaultStyle = LabelButtonStyle(
        size: .h40,
        variant: .outlined
    )

    private lazy var _style: LabelButtonStyle = defaultStyle

    public var style: LabelButtonStyle { defaultStyle }

    public convenience init(title: String?) {
        self.init()
        self.setTitle(title, for: .normal)
        _style = style
        applyColor()
        applyImage()
        applyContentsType()
        configureStyle()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _style = style
        applyColor()
        applyImage()
        applyContentsType()
        configureStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _style = style
        applyColor()
        applyImage()
        applyContentsType()
        configureStyle()
    }

    public override func awakeFromNib() {
        applyColor()
        applyContentsType()
        configureStyle()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyContentsType()
        configureStyle()
    }

    @IBInspectable public var color: String = "primary_a" {
        didSet {
            _color = YDSColor(name: color)
            applyColor()
            configureStyle()
        }
    }

    private var _color: YDSColor = YDSColor(name: "primary_a")

    @IBInspectable public var isRightIcon: Bool  = false {
        didSet {
            applyContentsType()
            configureStyle()
        }
    }

    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        configureStyle()
    }
    
    public override var isEnabled: Bool {
        didSet {
            configureLayer()
            configureBackground()
        }
    }
    
    public override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        _image = image
        applyContentsType()
        configureStyle()
    }

    private var _image: UIImage?

    public func setupStyle(_ style: LabelButtonStyle) {
        _style = style
        setupColor(from: style)
        setupImage(from: style)
        configureStyle()
    }
}

private extension LabelButton {

    func applyColor() {
        _style.color = _color
    }

    func applyImage() {
        _image = imageView?.image
    }

    func applyContentsType() {
        if let image = _image, image != UIImage() {
            _style.contentsType = isRightIcon ? .imageRight(image) : .imageLeft(image)
        } else {
            _style.contentsType = .textOnly
        }
    }

    func setupColor(from style: LabelButtonStyle) {
        _color = style.color
    }

    func setupImage(from style: LabelButtonStyle) {
        switch style.contentsType {
        case .imageRight(let image):
            imageView?.image = image
        case .imageLeft(let image):
            imageView?.image = image
        case .textOnly:
            imageView?.image = nil
        }
    }


    func configureStyle() {
        configureFrame()
        configureLayer()
        configureBackground()
        configureContents()
        configureConstraints()
    }

    func configureFrame() {
        var frame = frame
        frame.size.height = _style.size.rawValue
        self.frame = frame
    }

    func configureLayer() {
        layer.masksToBounds = true
        layer.cornerRadius = _style.size.cornerRadius
        layer.borderColor = isEnabled ? _style.borderColor.cgColor : _style.disabledBorderColor.cgColor
        layer.borderWidth = 1
    }

    func configureBackground() {
        backgroundColor = isEnabled ? _style.backgroundColor : .clear
        setBackgroundImage(nil, for: .normal)
        setBackgroundImage(_style.pressedBackgroundColor.image(), for: .highlighted)
        setBackgroundImage(_style.disabledBackgroundColor.image(), for: .disabled)
    }

    func configureContents() {
        switch _style.contentsType {
        case .textOnly:
            semanticContentAttribute = .unspecified
            imageEdgeInsets = .zero
        case .imageLeft:
            semanticContentAttribute = .forceLeftToRight
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: _style.imageInset)
        case .imageRight:
            semanticContentAttribute = .forceRightToLeft
            imageEdgeInsets = UIEdgeInsets(top: 0, left: _style.imageInset, bottom: 0, right: 0)
        }
        if #available(iOS 12.0, *) {
            super.setImage(_style.fittedImage(with: traitCollection), for: .normal)
        } else {
            super.setImage(_style.image, for: .normal)
        }
        tintColor = _style.contentsColor
        setTitleColor(_style.contentsColor, for: .normal)
        setTitleColor(_style.contentsColor, for: .highlighted)
        setTitleColor(_style.disabledContentsColor, for: .disabled)
        titleLabel?.font = _style.size.font
        adjustsImageWhenHighlighted = false
    }

    func configureConstraints() {
        let minimumWidth = _style.minimumWidth(withTitleWidth: titleLabel?.titleSize.width ?? 0)
        let widthConstraint = widthConstraint
        removeWidthHeightConstraints()
        makeSize(attribute: .width, constant: max(minimumWidth, widthConstraint))
        makeSize(attribute: .height, constant: _style.size.rawValue)
    }
}

public final class Contained56LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h56,
            variant: .contained
        )
    }
}

public final class Outlined56LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h56,
            variant: .outlined
        )
    }
}

public final class Text56LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h56,
            variant: .text
        )
    }
}

public final class Contained48LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h48,
            variant: .contained
        )
    }
}

public final class Outlined48LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h48,
            variant: .outlined
        )
    }
}

public final class Text48LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h48,
            variant: .text
        )
    }
}

public final class Contained40LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h40,
            variant: .contained
        )
    }
}

public final class Outlined40LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h40,
            variant: .outlined
        )
    }
}

public final class Text40LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h40,
            variant: .text
        )
    }
}

public final class Contained36LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h36,
            variant: .contained
        )
    }
}

public final class Outlined36LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h36,
            variant: .outlined
        )
    }
}

public final class Text36LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h36,
            variant: .text
        )
    }
}

public final class Contained32LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h32,
            variant: .contained
        )
    }
}

public final class Outlined32LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h32,
            variant: .outlined
        )
    }
}

public final class Text32LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h32,
            variant: .text
        )
    }
}

public final class Contained28LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h28,
            variant: .contained
        )
    }
}

public final class Outlined28LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h28,
            variant: .outlined
        )
    }
}

public final class Text28LabelButton: LabelButton {

    public override var style: LabelButtonStyle {
        LabelButtonStyle(
            size: .h28,
            variant: .text
        )
    }
}
