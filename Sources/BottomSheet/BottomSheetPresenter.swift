//
//  BottomSheetPresenter.swift
//  YDSKit
//
//  Created by Masher Shin on 2022/07/16.
//

import UIKit

protocol BottomSheetPresenter: AnyObject {
    func presentBottomSheet(_ viewControllerToPresent: BottomSheetPresentable.Presenter)
}

extension UIViewController: BottomSheetPresenter {
    public func presentBottomSheet(_ viewControllerToPresent: BottomSheetPresentable.Presenter) {
        
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: BundleProvider.self)
        #endif
        
        guard let bottomSheetContainer = UIStoryboard(name: "BottomSheet", bundle: bundle).instantiateInitialViewController() as? BottomSheetContainable else { return }
        bottomSheetContainer.present(
            viewControllerToPresent,
            toPresenting: bottomSheetContainer.topViewController() ?? self)
    }
}
