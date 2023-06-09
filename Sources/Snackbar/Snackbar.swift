//
//  Snackbar.swift
//
//
//  Created by 윤태민(Yun, Taemin) on 2022/12/07.
//

import UIKit
import SnapKit

public class Snackbar: UIView {
    static let offset = 8.0

    static var snackbar: Snackbar?
    static var style = SnackbarStyle()

    private var dismissTask: DispatchWorkItem?

    public static func show(imageName: String? = nil,
                            text: String,
                            buttonType: SnackbarButtonType? = nil,
                            style: SnackbarStyle = SnackbarStyle(),
                            in view: UIView,
                            canOverlap: Bool = true,
                            animatedInCompletion: (() -> Void)? = nil,
                            animatedOutCompletion: (() -> Void)? = nil) {
        let offset = offset + style.direction.getSafeAreaInset(in: view)
        if let snackbar = Snackbar.snackbar {
            guard canOverlap else { return }

            snackbar.dismiss(direction: Snackbar.style.direction.reverse) {
                Self.show(imageName: imageName,
                          text: text,
                          buttonType: buttonType,
                          style: style,
                          in: view,
                          animatedInCompletion: animatedInCompletion,
                          animatedOutCompletion: animatedOutCompletion)
            }

            if Snackbar.style.direction != style.direction {
                Snackbar.style.direction = style.direction.reverse
            }

            return
        }

        let snackbar = Snackbar()
        Snackbar.style = style
        snackbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(snackbar)

        snackbar.configureContainerView(in: view)
        snackbar.addStackView(imageName: imageName,
                              text: text,
                              buttonType: buttonType,
                              direction: style.direction)
        snackbar.animateIn(offset: offset,
                           direction: style.direction,
                           completion: animatedInCompletion)
        Snackbar.snackbar = snackbar

        snackbar.automaticDismissSetup(style,
                                       completion: animatedOutCompletion)
    }

    public static func close(animated: Bool, completion: (() -> Void)? = nil) {
        guard let snackbar = Self.snackbar else {
            (completion ?? { })()
            return
        }

        snackbar.animateOut(isOverlapped: animated == false,
                            direction: Snackbar.style.direction.reverse,
                            completion: completion)
    }

    public static var isPresenting: Bool {
        return Self.snackbar == nil ? false : true
    }
}

// MARK: - Configure
private extension Snackbar {
    func configureContainerView(in view: UIView) {
        backgroundColor = YDSColor(name: "gray_900_c").withAlphaComponent(0.9)      // TODO: 새로운 토큰 추가 예정(noti_bg)
        layer.cornerRadius = 12
        clipsToBounds = true

        let offset = 8.0
        snp.makeConstraints { make in
            switch Self.style.direction {
            case .upwards:
                make.bottom.equalTo(view.snp.bottom).inset(offset - 20)
            case .downwards:
                make.top.equalTo(view.snp.top).inset(offset - 20)
            }
            make.left.equalToSuperview().inset(offset)
            make.right.equalToSuperview().inset(offset)
        }
    }

    func addStackView(imageName: String?, text: String, buttonType: SnackbarButtonType?, direction: SnackbarStyle.Direction) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.backgroundColor = .clear

        if let imageName = imageName {
            addImageView(imageName, in: stackView)
        } else {
            addSpacingView(width: 16.0, in: stackView)
        }

        addDescriptionLabel(text, in: stackView)
        addButton(buttonType, in: stackView)

        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().inset(0)
            make.left.equalToSuperview().inset(0)
            make.right.equalToSuperview().inset(0)
        }
    }

    func addSpacingView(width: CGFloat, in stackView: UIStackView) {
        let spacingView = UIView()
        stackView.addArrangedSubview(spacingView)

        spacingView.snp.makeConstraints { make in
            make.width.equalTo(width)
        }
    }

    func addImageView(_ imageName: String, in stackView: UIStackView) {
        guard let image = UIImage(named: imageName) else { return }

        let imageView = UIImageView()
        imageView.image = image
        imageView.sizeToFit()

        stackView.addArrangedSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        addSpacingView(width: 8, in: stackView)
    }

    func addDescriptionLabel(_ text: String, in stackView: UIStackView) {
        let label = InsetLabel()
        label.backgroundColor = .clear
        label.textColor = YDSColor(name: "gray_800_c_i")
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14.0)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 19

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle,
                                      range: NSMakeRange(0, attributedString.length))

        label.attributedText = attributedString

        stackView.addArrangedSubview(label)
    }

    func addButton(_ buttonType: SnackbarButtonType?, in stackView: UIStackView) {
        guard let buttonType = buttonType else {
            addSpacingView(width: 16.0, in: stackView)
            return
        }

        var button = UIButton()
        switch buttonType {
        case .image(let imageName):
            button = makeButton(imageName: imageName)
        case .text(let text):
            button = makeButton(title: text)
        }

        addSpacingView(width: 8, in: stackView)
        stackView.addArrangedSubview(button)

        addSpacingView(width: buttonType.rightMarginInSuperView, in: stackView)
    }

    func makeButton(imageName: String) -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
        }

        return button
    }

    func makeButton(title: String = "확인") -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)

        let attributedString = NSMutableAttributedString(string: title)
        let range = NSRange(location: 0, length: title.count)
        let font = UIFont.systemFont(ofSize: 14.0)
        let color = YDSColor(name: "primary_a")

        attributedString.addAttribute(.font, value: font, range: range)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)

        button.setAttributedTitle(attributedString, for: .normal)
        button.sizeToFit()
        button.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.width.equalTo(button.frame.width)
        }

        return button
    }

    @objc func closeButtonClicked() {
        animateOut(isOverlapped: false, direction: Snackbar.style.direction.reverse)
    }
}

private extension Snackbar {
    func animateIn(offset: CGFloat,
                   direction: SnackbarStyle.Direction,
                   completion: (() -> Void)?) {
        self.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.7,
                       options: .curveEaseOut,
                       animations: {
            self.alpha = 1
            self.snp.updateConstraints { make in
                switch direction {
                case .upwards:
                    make.bottom.equalToSuperview().inset(offset)
                case .downwards:
                    make.top.equalToSuperview().inset(offset)
                }
            }
            self.superview?.layoutIfNeeded()
        }) { _ in
            (completion ?? { })()
        }
    }

    func automaticDismissSetup(_ style: SnackbarStyle,
                               completion: (() -> Void)?) {
        let task = DispatchWorkItem { [weak self] in
            switch style.direction {
            case .upwards:
                self?.animateOut(isOverlapped: false,
                                 direction: .downwards,
                                 completion: completion)
            case .downwards:
                self?.animateOut(isOverlapped: false,
                                 direction: .upwards,
                                 completion: completion)
            }
        }
        self.dismissTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + style.duration.value,
                                      execute: task)
    }

    func animateOut(isOverlapped: Bool, direction: SnackbarStyle.Direction, completion: (() -> Void)? = nil) {
        let duration: CGFloat = isOverlapped ? 0 : 0.3
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let self = self,
                  let superView = self.superview else {
                return
            }
            self.alpha = 0
            self.snp.updateConstraints { make in
                switch direction {
                case .upwards:
                    make.top.equalTo(superView).inset(Snackbar.offset - 20)
                case .downwards:
                    make.bottom.equalTo(superView).inset(Snackbar.offset - 20)
                }
            }
            self.superview?.layoutIfNeeded()
        }, completion: { _ in
            Snackbar.snackbar = nil
            self.removeFromSuperview()
            completion?()
        })
    }

    func dismiss(direction: SnackbarStyle.Direction, _ completion: @escaping (() -> Void)) {
        if let task = dismissTask {
            task.cancel()
        }

        animateOut(isOverlapped: Self.snackbar != nil, direction: direction, completion: completion)
    }
}

private class InsetLabel: UILabel {

    let textInsets = UIEdgeInsets(top: 17, left: 0, bottom: 16, right: 0)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += textInsets.top + textInsets.bottom
        contentSize.width += textInsets.left + textInsets.right
        return contentSize
    }
}
