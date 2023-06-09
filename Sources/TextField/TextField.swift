//
//  TextField.swift
//  YDSKit
//
//  Created by Gilwoo Hwang on 2022/06/27.
//

import UIKit

public extension String {
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

private class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets()

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        guard let text = text,
              text.isBlank == false else { return contentSize }
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }

    override func sizeToFit() {
        super.sizeToFit()
        guard let text = text,
              text.isBlank == false else { return }
        var size = bounds.size
        size.width += (padding.left + padding.right)
        bounds.size = size
    }
}

public class TextField: UITextField {

    public override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }

    public override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        if isSecureTextEntry,
            let text = text {
            deleteBackward()
            insertText(text)
        }
        return success
    }

    private let defaultStyle = TextFieldStyle(
        size: .h56,
        color: YDSColor(name: "gray_100_c"),
        variant: .outlined
    )
    private let clearImageName: String = "ic_text_delete"
    private let searchImageName: String = "ic_search"
    private let minimumWidth: CGFloat = 120
    private let borderWidth: CGFloat = 1

    private let innerLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let outerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let borderLayer: CALayer = {
        let layer = CALayer()
        layer.masksToBounds = true
        layer.anchorPoint = .zero
        return layer
    }()

    private let backgroundColorLayer: CALayer = {
        let layer = CALayer()
        layer.masksToBounds = true
        layer.anchorPoint = .zero
        return layer
    }()

    private lazy var lView: UIView = {
        let leading = UIView()
        leading.translatesAutoresizingMaskIntoConstraints = false
        leading.addSubview(searchImg)
        return leading
    }()

    private lazy var searchImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.layer.anchorPoint = .zero
        return img
    }()

    private lazy var rView: UIStackView = {
        let leading = UIView()
        let l = leading.widthAnchor.constraint(equalToConstant: _style.size.iconPadding)
        leading.addConstraint(l)
        let trailing = UIView()
        let view = UIStackView(arrangedSubviews: [leading, clearButton, suffixLabel])
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var clearButton: UIButton = {
        let clearButton = UIButton(type: .custom)
        clearButton.addTarget(self, action:  #selector(clearClicked(sender:)), for: .touchUpInside)
        clearButton.isHidden = true
        return clearButton
    }()

    private weak var timer: Timer?
    private var didEnterBackgroundDate: Date?

    private lazy var suffixLabel: UILabel = {
        let padding = _style.size.iconPadding
        let label = PaddingLabel(padding: UIEdgeInsets(top: 0,
                                                       left: padding,
                                                       bottom: 0,
                                                       right: padding))
        label.numberOfLines = 1
        label.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(suffixClicked(sender:)))
        tap.numberOfTouchesRequired = 1
        label.addGestureRecognizer(tap)
        return label
    }()

    private lazy var _style: TextFieldStyle = defaultStyle
    private var _suffix: String? = nil {
        didSet {
            suffixLabel.text = _suffix
            suffixLabel.isHidden = _suffix == nil
            suffixLabel.sizeToFit()
        }
    }

    public var style: TextFieldStyle { _style }

    private var _color: YDSColor = YDSColor(name: "primary_a") {
        didSet {
            _style.color = _color
            configureColor()
        }
    }

    private var helpMessage: String? = nil {
        didSet {
            outerLabel.text = helpMessage
            outerLabel.isHidden = helpMessage == nil
        }
    }
    
    private var labelMessage: String? = nil {
        didSet {
            innerLabel.text = labelMessage
            innerLabel.isHidden = labelMessage == nil
        }
    }

    public override var isEnabled: Bool {
        didSet {
            configureColor()
        }
    }

    public var estimateHeight: CGFloat {
        var height = _style.size.rawValue
        if hasOuterLabelText {
            outerLabel.sizeToFit()
            height += _style.helpTopPadding + outerLabel.bounds.size.height
        }
        return height
    }

    deinit {
        removeObservers()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _style = style
        commonInit()
        applyContentsType()
        configureStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _style = style
        commonInit()
        applyContentsType()
        configureStyle()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        applyContentsType()
        configureStyle()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configureStyle()
    }

    @IBInspectable public var suffix: String? = nil {
        didSet {
            _suffix = suffix
            applyContentsType()
            configureStyle()
        }
    }

    @IBInspectable public var helpText: String? = nil {
        didSet {
            helpMessage = helpText
            configureStyle()
        }
    }
    
    @IBInspectable public var labelText: String? = nil {
        didSet {
            labelMessage = labelText
        }
    }

    @IBInspectable public var color: String = "primary_a" {
        didSet {
            _color = YDSColor(name: color)
        }
    }

    @IBInspectable public var isError: Bool = true {
        didSet {
            configureColor()
        }
    }

    @IBInspectable public var clearErrorWhenEditing: Bool = true

    @IBInspectable public var maxSec: Int = 180
    private var timeLeft: Int = 0

    public func setupStyle(_ style: TextFieldStyle) {
        _style = style
        applyContentsType()
        configureStyle()
    }

    public func startTimer() {
        startTimer(from: maxSec)
    }
}

private extension TextField {

    var requiredSize: CGSize {
        let width = max(minimumWidth, widthConstraint, bounds.width)
        let height = _style.size.rawValue
        return CGSize(width: width, height: height)
    }

    func commonInit() {
        addSubview(innerLabel)
        addSubview(outerLabel)

        borderStyle = .none
        adjustsFontSizeToFitWidth = false

        addTarget(self, action: #selector(_textFieldBeginEditing(sender:)), for: .editingDidBegin)
        addTarget(self, action: #selector(_textFieldChangeEditing(sender:)), for: .editingChanged)
        addTarget(self, action: #selector(_textFieldEndEditing(sender:)), for: .editingDidEnd)

        rView.addArrangedSubview(clearButton)
        rView.addArrangedSubview(suffixLabel)

        clearButtonMode = .never
        leftView = lView
        rightViewMode = .always
        rightView = rView

        translatesAutoresizingMaskIntoConstraints = false

        let searchImage = UIImage(named: searchImageName,
                                 in: YDSKitEnvironment.shared.bundle,
                                 compatibleWith: nil)
        searchImg.image = searchImage
    }

    func applyContentsType() {
        let clearImage = UIImage(named: clearImageName,
                                 in: YDSKitEnvironment.shared.bundle,
                                 compatibleWith: nil)?
            .resize(to: _style.size.iconSize)
        clearButton.setImage(clearImage, for: .normal)

        removeObservers()

        let type = _style.contentsType

        switch type {
            case .text:
                leftViewMode = .never
                isSecureTextEntry = false
                suffixLabel.isUserInteractionEnabled = false
            case .password(let secure):
                leftViewMode = .never
                isSecureTextEntry = secure
                suffixLabel.isUserInteractionEnabled = true
                _suffix = secure ? "보기" : "가리기"
                let _ = becomeFirstResponder()
            case .search:
                leftViewMode = .always
                isSecureTextEntry = false
                suffixLabel.isUserInteractionEnabled = false
            case .certified:
                leftViewMode = .never
                isSecureTextEntry = false
                suffixLabel.isUserInteractionEnabled = false
                _suffix = map(timeStamp: maxSec)
                addObservers()
        }
    }

    func setupColor(from style: TextFieldStyle) {
        switch style.variant {
            case .text:
                return
            case .contained, .outlined:
                configureColor()
        }
    }

    func configureStyle() {
        configureFrame()
        configureLayer()
        configureColor()
        configureContents()
        configureConstraints()
        checkClearWhenDone(sender: self)
    }

    func configureFrame() {
        let size = requiredSize
        borderLayer.bounds.size = size
        backgroundColorLayer.bounds.size = size
    }

    func configureLayer() {
        borderLayer.cornerRadius = _style.size.cornerRadius
        borderLayer.borderWidth = borderWidth
        layer.insertSublayer(borderLayer, at: 0)

        backgroundColorLayer.cornerRadius = _style.size.cornerRadius
        layer.insertSublayer(backgroundColorLayer, at: 1)
    }

    func configureColor() {
        switch _style.variant {
            case .outlined:
                configureColorAsOutlined()
            case .contained:
                configureColorAsContained()
            default:
                return
        }

        backgroundColorLayer.backgroundColor = isEnabled ? UIColor.clear.cgColor : YDSColor(name: "overlay_disabled").cgColor

        textColor = YDSColor(name: "gray_800_c")
        outerLabel.textColor = isError ? YDSColor(name: "ygy_orange") : YDSColor(name: "gray_400_c")
        innerLabel.textColor = YDSColor(name: "gray_300_c")

        if let holderText = placeholder {
            attributedPlaceholder = NSAttributedString(string: holderText,
                                                       attributes: [NSAttributedString.Key.foregroundColor : YDSColor(name: "gray_300_c")])
        }

        guard hasOuterLabelText && isError else { return }
        borderLayer.borderColor = YDSColor(name: "ygy_orange").cgColor
    }

    func configureColorAsOutlined() {
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.borderColor = _style.color.cgColor
    }

    func configureColorAsContained() {
        borderLayer.backgroundColor = _style.color.cgColor
        borderLayer.borderColor = UIColor.clear.cgColor
    }

    func checkBorderColor() {
        guard _style.variant == .outlined else { return }
        borderLayer.borderColor = isFirstResponder ? _style.firstResponderColor.cgColor : _style.color.cgColor
    }

    func configureContents() {
        font = _style.font
        outerLabel.font = _style.helpFont
        innerLabel.font = _style.labelFont
        suffixLabel.font = _style.suffixFont
    }

    func configureConstraints() {
        removeWidthHeightConstraints()
        let size = requiredSize
        makeSize(attribute: .width, constant: size.width)
        makeSize(attribute: .height, constant: estimateHeight)
        
        addInnerConstraint()
        addOuterConstraint()
        addClearButtonConstraint()
        addSearchViewConstraint()
    }
    
    func addInnerConstraint() {
        innerLabel.removePositionConstraints()

        let leading = innerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: _style.leftPadding)
        let trailing = innerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -_style.rightPadding)
        let top = innerLabel.topAnchor.constraint(equalTo: topAnchor, constant: _style.labelTopPadding)
        addConstraints([leading, trailing, top])
    }
    
    func addOuterConstraint() {
        outerLabel.removePositionConstraints()

        let leading = outerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: _style.helpLeftPadding)
        let trailing = outerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -_style.helpRightPadding)
        let bottom = outerLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        addConstraints([leading, trailing, bottom])
    }
    
    func addClearButtonConstraint() {
        clearButton.removeWidthHeightConstraints()
        let clearButtonWidth = _style.size.iconAreaWidth
        clearButton.makeSize(attribute: .width, constant: clearButtonWidth)
        clearButton.makeSize(attribute: .height, constant: requiredSize.height)
    }

    func addSearchViewConstraint() {
        lView.removeWidthHeightConstraints()
        let width = lView.widthAnchor.constraint(equalToConstant: _style.size.iconAreaWidth)
        let height = lView.heightAnchor.constraint(equalToConstant: _style.size.rawValue)
        lView.addConstraints([width, height])

        let estimateY = (_style.size.rawValue - _style.size.iconSize.height) / 2
        searchImg.frame = CGRect(x: _style.size.iconPadding,
                                 y: estimateY,
                                 width: _style.size.iconSize.width,
                                 height: _style.size.iconSize.height)
    }

    func checkClearButton(sender: UITextField) {
        guard let text = text,
              text.isBlank == false else {
            return hideClear()
        }
        showClear()
    }

    func checkClearWhenDone(sender: UITextField) {
        guard case .search = _style.contentsType,
              let text = text,
              text.isBlank == false else {
            return hideClear()
        }
        showClear()
    }

    func showClear() {
        clearButton.isHidden = false
    }

    func hideClear() {
        clearButton.isHidden = true
    }
}

public extension TextField {

    override var intrinsicContentSize: CGSize {
        let textFieldIntrinsicContentSize = super.intrinsicContentSize
        let height = estimateHeight
        return CGSize(width: textFieldIntrinsicContentSize.width,
               height: height)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return insetRectLabelBounds(rect: rect)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return insetRectLabelBounds(rect: rect)
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return insetForLeftView(forBounds: rect)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return insetForRightView(forBounds: rect)
    }

    private func insetRectLabelBounds(rect: CGRect) -> CGRect {
        configureFrame()
        let left: CGFloat
        if case .search = _style.contentsType {
            left = _style.leftPadding + _style.size.iconAreaWidth
        } else {
            left = _style.leftPadding
        }
        var height = rect.size.height
        if hasInnerLabelText {
            height += _style.labelTopPadding
            height += innerLabel.bounds.size.height
            height -= _style.bottomPadding
        }
        if hasOuterLabelText {
            height -= _style.helpTopPadding
            height -= outerLabel.bounds.size.height
        }
        height += borderWidth
        var width = rect.size.width - left - _style.size.iconPadding
        if leftViewMode == .always {
            width += lView.bounds.width + _style.size.iconPadding
        }
        let new = CGRect(x: left, y: 0, width: width, height: height)
        return new
    }

    private func insetForLeftView(forBounds bounds: CGRect) -> CGRect {
        let size = requiredSize
        let leading: CGFloat = _style.size.iconPadding
        let rWidth = _style.size.iconAreaWidth
        let new = CGRect(x: leading, y: 0, width: rWidth, height: size.height)
        return new
    }

    private func insetForRightView(forBounds bounds: CGRect) -> CGRect {
        let size = requiredSize
        let trailing: CGFloat = _style.size.iconPadding
        let clearWidth = clearButton.isHidden ? 0 : clearButton.bounds.width
        let suffixWidth = suffixLabel.isHidden ? 0 : suffixLabel.bounds.width
        let rWidth = trailing + clearWidth + suffixWidth
        let new = CGRect(x: size.width - rWidth - trailing, y: 0, width: rWidth, height: size.height)
        return new
    }

}

private extension TextField {
    var hasInnerLabelText: Bool {
        guard let text = innerLabel.text else { return false }
        return text.isBlank == false
    }
    
    var hasOuterLabelText: Bool {
        guard let text = outerLabel.text else { return false }
        return text.isBlank == false
    }

    @objc func clearClicked(sender: UIButton) {
        text = nil
        sendActions(for: .editingChanged)
    }

    @objc func suffixClicked(sender: UITapGestureRecognizer) {
        if case .password(let secure) = _style.contentsType {
            var style = _style
            style.contentsType = .password(secure: !secure)
            setupStyle(style)
            checkClearButton(sender: self)
        }
    }

    @objc func _textFieldBeginEditing(sender: UITextField) {
        if isError && clearErrorWhenEditing {
            helpText = nil
        }
        checkBorderColor()
        checkClearButton(sender: sender)
    }

    @objc func _textFieldChangeEditing(sender: UITextField) {
        checkBorderColor()
        checkClearButton(sender: sender)
    }

    @objc func _textFieldEndEditing(sender: UITextField) {
        configureColor()
        checkClearWhenDone(sender: sender)
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(_didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func _didEnterBackground() {
        stopTimer()
        didEnterBackgroundDate = Date()
    }

    @objc func _willEnterForeground() {
        let difference = Date().timeIntervalSince(didEnterBackgroundDate ?? Date())
        didEnterBackgroundDate = nil
        timeLeft -= Int(round(difference))

        guard timeLeft > 0 else {
            isEnabled = false
            _suffix = "0:00"
            return
        }
        startTimer(from: timeLeft)
    }

    @objc func timerFire() {
        timeLeft -= 1
        _suffix = map(timeStamp: timeLeft)
        if timeLeft <= 0 {
            isEnabled = false
            stopTimer()
        }
    }

    func startTimer(from: Int) {
        stopTimer()
        timeLeft = from
        isEnabled = true
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFire), userInfo: nil, repeats: true)
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func map(timeStamp: Int) -> String {
        guard timeStamp > 0 else { return "0:00" }
        let minutes = timeStamp / 60
        let seconds = timeStamp % 60
        return String(format: "%0.1d:%0.2d", minutes, seconds)
    }
}
