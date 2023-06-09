//
//  ChipButton.swift
//  YDSKit
//
//  Created by 신범철(Shin, Beomcheol) on 2022/02/16.
//

import UIKit

public class ChipButton: UIButton {

    private let defaultStyle = ChipButtonStyle(
        height: .h40,
        variant: .outlined
    )

    private lazy var _style: ChipButtonStyle = defaultStyle

    public var style: ChipButtonStyle { defaultStyle }

    public convenience init(title: String?) {
        self.init()
        self.setTitle(title, for: .normal)
        _style = style
        applyColor()
        applyImage()
        applyContentsType()
        applySelectedColor()
        configureStyle()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _style = style
        applyColor()
        applyImage()
        applyContentsType()
        applySelectedColor()
        configureStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _style = style
        applyColor()
        applyImage()
        applyContentsType()
        applySelectedColor()
        configureStyle()
    }

    public override func awakeFromNib() {
        applyColor()
        applyContentsType()
        applySelectedColor()
        configureStyle()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyContentsType()
        configureStyle()
    }

    @IBInspectable public var color: String = "gray_c" {
        didSet {
            _color = YDSColor(name: color)
            applyColor()
            configureStyle()
        }
    }

    private var _color: YDSColor = YDSColor(name: "gray_c")

    @IBInspectable public var isRightIcon: Bool  = false {
        didSet {
            applyContentsType()
            configureStyle()
        }
    }

    @IBInspectable public var selectedColor: String? = nil {
        didSet {
            applySelectedColor()
            configureStyle()
        }
    }

    public override var isSelected: Bool {
        didSet {
            applySelectedColor()
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

    public func setupStyle(_ style: ChipButtonStyle) {
        _style = style
        setupColor(from: style)
        setupImage(from: style)
        configureStyle()
    }
}

private extension ChipButton {

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

    func applySelectedColor() {
        guard let selectedColor = selectedColor else { return }
        _style.selectedColor = YDSColor(name: selectedColor)
        _style.selected = isSelected
    }

    func setupColor(from style: ChipButtonStyle) {
        _color = style.color
    }

    func setupImage(from style: ChipButtonStyle) {
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
        frame.size.height = _style.height.rawValue
        self.frame = frame
    }

    func configureLayer() {
        layer.masksToBounds = true
        layer.cornerRadius = _style.height.rawValue / 2
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
        titleLabel?.font = UIFont.systemFont(ofSize: _style.height.textSize, weight: _style.isBold ? .bold : .regular)
        adjustsImageWhenHighlighted = false
    }

    func configureConstraints() {
        let minimumWidth = _style.minimumWidth(withTitleWidth: titleLabel?.titleSize.width ?? 0)
        removeWidthHeightConstraints()
        makeSize(attribute: .width, constant: minimumWidth)
        makeSize(attribute: .height, constant: _style.height.rawValue)
    }
}

public final class Contained40ChipButton: ChipButton {

    public override var style: ChipButtonStyle {
        ChipButtonStyle(
            height: .h40,
            variant: .contained
        )
    }
}

public final class Outlined40ChipButton: ChipButton {

    public override var style: ChipButtonStyle {
        ChipButtonStyle(
            height: .h40,
            variant: .outlined
        )
    }
}

public final class Text40ChipButton: ChipButton {

    public override var style: ChipButtonStyle {
        ChipButtonStyle(
            height: .h40,
            variant: .text
        )
    }
}

public final class Contained36ChipButton: ChipButton {

    public override var style: ChipButtonStyle {
        ChipButtonStyle(
            height: .h36,
            variant: .contained
        )
    }
}

public final class Outlined36ChipButton: ChipButton {

    public override var style: ChipButtonStyle {
        ChipButtonStyle(
            height: .h36,
            variant: .outlined
        )
    }
}

public final class Text36ChipButton: ChipButton {

    public override var style: ChipButtonStyle {
        ChipButtonStyle(
            height: .h36,
            variant: .text
        )
    }
}

public final class Contained32ChipButton: ChipButton {

    public override var style: ChipButtonStyle {
        ChipButtonStyle(
            height: .h32,
            variant: .contained
        )
    }
}

public final class Outlined32ChipButton: ChipButton {

    public override var style: ChipButtonStyle {
        ChipButtonStyle(
            height: .h32,
            variant: .outlined
        )
    }
}

public final class Text32ChipButton: ChipButton {

    public override var style: ChipButtonStyle {
        ChipButtonStyle(
            height: .h32,
            variant: .text
        )
    }
}

public final class Contained20ChipButton: ChipButton {

    public override var style: ChipButtonStyle {
        ChipButtonStyle(
            height: .h20,
            variant: .contained
        )
    }
}

public final class Outlined20ChipButton: ChipButton {

    public override var style: ChipButtonStyle {
        ChipButtonStyle(
            height: .h20,
            variant: .outlined
        )
    }
}
