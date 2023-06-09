//
//  BottomSheetContainerViewController.swift
//  YDSKit
//
//  Created by Masher Shin on 2022/07/15.
//

import UIKit
import PanModal

typealias BottomSheetContainable = BottomSheetContainerViewController & PanModalPresentable

public class BottomSheetContainerViewController: UIViewController {

    @IBOutlet private var headerHeight: NSLayoutConstraint!
    @IBOutlet private var contentsHeight: NSLayoutConstraint!
    @IBOutlet private var contentsBottom: NSLayoutConstraint!
    @IBOutlet private var contentsSideMargins: [NSLayoutConstraint]!
    @IBOutlet private var footerHeight: NSLayoutConstraint!
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var footerView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var button1: UIButton!
    @IBOutlet private var button2: UIButton!

    private let contentsSegue = "Contents"

    private weak var contentsViewController: BottomSheetPresentable.Presenter?

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout(with: contentsViewController?.type)
        configureContents(with: contentsViewController?.type)
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        addContentsView(from: segue)
    }

    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        if flag == false {
            presentingViewController?.beginAppearanceTransition(true, animated: true)
            presentingViewController?.endAppearanceTransition()
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func button1Action(_ sender: Any) {
        contentsViewController?.type.ctaType.actionOne?()
    }

    @IBAction func button2Action(_ sender: Any) {
        contentsViewController?.type.ctaType.actionTwo?()
    }

    func present(_ contents: BottomSheetPresentable.Presenter?, toPresenting presenting: UIViewController) {
        contentsViewController = contents
        modalPresentationStyle = .custom
        modalPresentationCapturesStatusBarAppearance = true
        transitioningDelegate = PanModalPresentationDelegate.default
        presenting.present(self, animated: true)
    }

}

private extension BottomSheetContainerViewController {

    func addContentsView(from segue: UIStoryboardSegue) {
        guard segue.identifier == contentsSegue,
        let contentsViewController = contentsViewController else { return }
        let destination = segue.destination
        destination.addChild(contentsViewController)
        destination.view.translatesAutoresizingMaskIntoConstraints = false
        destination.view.addSubview(contentsViewController.view)
        contentsViewController.didMove(toParent: destination)
    }

    func configureLayout(with type: ButtomSheetType?) {
        guard let type = type else { return }
        headerHeight.constant = type.headerHeight
        contentsHeight.constant = type.minimumContentsHeight
        contentsBottom.constant = type.contentsBottom
        contentsSideMargins.forEach { $0.constant = contentsViewController?.contentsSideMargin ?? 16 }
        footerHeight.isActive = type.isActiveFooterHeight
        footerHeight.constant = type.footerHeight
        headerView.isHidden = type.isHiddenHeader
        footerView.isHidden = type.isHiddenFooter
        button2.isHidden = type.ctaType.isOneButton
    }

    func configureContents(with type: ButtomSheetType?) {
        titleLabel.text = type?.title
        button1.setTitle(type?.ctaType.titleOne, for: .normal)
        button2.setTitle(type?.ctaType.titleTwo, for: .normal)
    }
}

extension BottomSheetContainerViewController: PanModalPresentable {

    public var panScrollable: UIScrollView? { nil }

    public var topOffset: CGFloat { topLayoutOffset + 32 }

    public var cornerRadius: CGFloat { 16 }

    public var panModalBackgroundColor: UIColor { .black.withAlphaComponent(0.6) }

    public var showDragIndicator: Bool { false }

    public var longFormHeight: PanModalHeight {
        guard let contentsViewController = contentsViewController,
              let height = contentsViewController.contentsHeight
        else { return defaultLongFormHeight }
        return .contentHeight(contentsViewController.type.maximumHeight(with: height))
    }
}

#if SWIFT_PACKAGE
extension BottomSheetContainerViewController {
    public static func initializeWithStoryBoard() -> BottomSheetContainerViewController {
        UIStoryboard(name: "BottomSheet", bundle: Bundle.module)
            .instantiateViewController(withIdentifier: "BottomSheetContainerViewController") as! BottomSheetContainerViewController
    }
}
#endif

extension PanModalPresentable {

    var defaultLongFormHeight: PanModalHeight {

        guard let scrollView = panScrollable
            else { return .maxHeight }

        // called once during presentation and stored
        scrollView.layoutIfNeeded()
        return .contentHeight(scrollView.contentSize.height)
    }

    var topLayoutOffset: CGFloat {

        guard let rootVC = rootViewController
            else { return 0}

        if #available(iOS 11.0, *) { return rootVC.view.safeAreaInsets.top } else { return rootVC.topLayoutGuide.length }
    }

    var rootViewController: UIViewController? {

        guard let application = UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as? UIApplication
        else { return nil }

        return application.keyWindow?.rootViewController
    }


    func topViewController(_ viewController: UIViewController? = nil) -> UIViewController? {
        let viewController = viewController ?? rootViewController
        guard let presented = viewController?.presentedViewController else { return viewController }

        return topViewController(presented)
    }
}
