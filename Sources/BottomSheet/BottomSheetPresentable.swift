//
//  BottomSheetPresentable.swift
//  YDSKit
//
//  Created by Masher Shin on 2022/07/15.
//

import UIKit

public protocol BottomSheetPresentable {

    var panScrollable: UIScrollView? { get }

    var type: ButtomSheetType { get }

    var contentsHeight: CGFloat? { get }

    var contentsSideMargin: CGFloat { get }
}

public extension BottomSheetPresentable where Self: UIViewController {

    typealias Presenter = UIViewController & BottomSheetPresentable

    var panScrollable: UIScrollView? { nil }

    var contentsHeight: CGFloat? {
        guard case .button = type else { return nil }
        return type.minimumHeight
    }

    var contentsSideMargin: CGFloat { 16 }
}
