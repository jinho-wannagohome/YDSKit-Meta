//
//  CenterPopup.swift
//
//
//  Created by 윤태민(Yun, Taemin) on 2023/02/26.
//

import UIKit

public class CenterPopup: UIViewController {

    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private var contentsView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!

    @IBOutlet private var buttonsStackView: UIStackView!

    private let animated: Bool = true
    private var attributedTitle: NSMutableAttributedString?
    private var attributedMessage: NSMutableAttributedString?
    private var centerPopupColor: UIColor?
    private var centerPopupButtons: [CenterPopupButton]?

    private init(attributedTitle: NSMutableAttributedString?,
                 attributedMessage: NSMutableAttributedString?,
                 centerPopupColor: UIColor?,
                 centerPopupButtons: [CenterPopupButton]?) {
        super.init(nibName: "CenterPopup", bundle: Bundle.module)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext

        self.attributedTitle = attributedTitle
        self.attributedMessage = attributedMessage
        self.centerPopupColor = centerPopupColor
        self.centerPopupButtons = centerPopupButtons
    }

    public convenience init(attributedTitle: NSMutableAttributedString? = NSMutableAttributedString(string: "요기요"),
                            attributedMessage: NSMutableAttributedString?,
                            centerPopupColor: UIColor? = YDSColor(name: "top_bg")) {
        self.init(attributedTitle: attributedTitle,
                  attributedMessage: attributedMessage,
                  centerPopupColor: centerPopupColor,
                  centerPopupButtons: nil)
    }

    public convenience init(attributedTitle: NSMutableAttributedString? = NSMutableAttributedString(string: "요기요"),
                            attributedMessage: NSMutableAttributedString?,
                            centerPopupColor: UIColor? = YDSColor(name: "top_bg"),
                            primaryButton: CenterPopupButton) {
        self.init(attributedTitle: attributedTitle,
                  attributedMessage: attributedMessage,
                  centerPopupColor: centerPopupColor,
                  centerPopupButtons: [primaryButton])
    }

    public convenience init(attributedTitle: NSMutableAttributedString? = NSMutableAttributedString(string: "요기요"),
                            attributedMessage: NSMutableAttributedString?,
                            centerPopupColor: UIColor? = YDSColor(name: "top_bg"),
                            primaryButton: CenterPopupButton,
                            secondaryButton: CenterPopupButton) {
        self.init(attributedTitle: attributedTitle,
                  attributedMessage: attributedMessage,
                  centerPopupColor: centerPopupColor,
                  centerPopupButtons: [primaryButton, secondaryButton])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureTitle()
        configureMessage()
        configureButtons()
        configureViews()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureAnimation()
    }

    public func present(completion: (() -> Void)? = nil) {
        if #available(iOS 13, *) {
            if var topController = UIApplication.shared.windows.first?.rootViewController  {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                self.modalPresentationStyle = .overCurrentContext
                topController.present(self, animated: animated, completion: completion)
            }
        } else {
            UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: animated, completion: completion)
        }
    }

    @objc func backgroundViewTapped() {
        dismissWithAnimation()
    }

    @objc func primaryButtonPressed() {
        guard let centerPopupButtons = centerPopupButtons else {
            dismissWithAnimation()
            return
        }

        dismissWithAnimation(completion: centerPopupButtons.first?.dismissCompletion)
    }

    @objc func secondaryButtonPressed() {
        guard let centerPopupButtons = centerPopupButtons else {
            self.dismiss(animated: animated)
            return
        }

        dismissWithAnimation(completion: centerPopupButtons.last?.dismissCompletion)
    }

    private func dismissWithAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, animations: {
            let screenHeight = UIScreen.main.bounds.size.height
            self.contentsView.frame.origin.y = screenHeight
            self.dismiss(animated: self.animated, completion: completion)
        })
    }
}

// MARK: - Configure
private extension CenterPopup {

    func configureTitle() {
        guard let attributedString = attributedTitle else {
            titleLabel.isHidden = true
            return
        }

        let font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 24
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraphStyle]
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))

        titleLabel.attributedText = attributedString
    }

    func configureMessage() {
        guard let attributedString = attributedMessage else {
            messageLabel.isHidden = true
            return
        }

        let font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 22
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraphStyle]
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))

        messageLabel.attributedText = attributedString
    }

    func configureViews() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        gestureRecognizer.delegate = self
        backgroundView.addGestureRecognizer(gestureRecognizer)
        contentsView.backgroundColor = centerPopupColor
        contentsView.layer.cornerRadius = 16
        contentsView.clipsToBounds = true
    }

    func configureButtons() {
        guard let primaryButton = centerPopupButtons?.first else {
            buttonsStackView.isHidden = true
            return
        }

        if centerPopupButtons?.count == 2,
           let secondaryButton = centerPopupButtons?.last {

            let secondaryLabelButton = secondaryButton.labelButton
            secondaryLabelButton.addTarget(self, action: #selector(secondaryButtonPressed), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(secondaryLabelButton)
        }

        let primaryLabelButton = primaryButton.labelButton
        primaryLabelButton.addTarget(self, action: #selector(primaryButtonPressed), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(primaryLabelButton)
    }

    func configureAnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0, animations: {
                self.contentsView.frame.origin.y = UIScreen.main.bounds.size.height
            }) { _ in
                UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0) {
                    let contentsViewHeight = self.contentsView.frame.height
                    let screenHeight = UIScreen.main.bounds.size.height
                    self.contentsView.frame.origin.y = (screenHeight - contentsViewHeight) / 2
                }
            }
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CenterPopup: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
         if touch.view?.isDescendant(of: contentsView) == true {
            return false
         }
         return true
    }
}
