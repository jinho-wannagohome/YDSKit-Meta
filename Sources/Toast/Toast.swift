//
//  Toast.swift
//  
//
//  Created by 윤태민(Yun, Taemin) on 2022/11/30.
//

import UIKit
import Toaster

public class Toast {
    private let toast: Toaster.Toast
    
    public init(text: String, duration: Duration = .short, in view: UIView? = nil) {
        
        toast = Toaster.Toast(text: text, duration: duration.rawValue)
        configureStyle(text: text, in: view)
        
    }
    
    public func show() {
        toast.show()
    }
    
    public func cancel() {
        toast.cancel()
    }
    
    public enum Duration: CGFloat {
        case short = 1.5
        case long = 3.0
    }
}

// MARK: - Configure

private extension Toast {
    func configureStyle(text: String, in view: UIView?) {
        configureFrame()
        configureColor()
        configureAttributes(text: text)
        configureOffset(in: view)
    }
    
    func configureFrame() {
        toast.view.textInsets = UIEdgeInsets(top: 17, left: 20, bottom: 16, right: 20)
        
        let screenWidth = UIScreen.main.bounds.width
        
        if screenWidth > (360.0 + 60.0) {
            toast.view.maxWidthRatio = 360.0 / screenWidth
        } else {
            toast.view.maxWidthRatio = (screenWidth - 60) / screenWidth
        }
    }
    
    func configureColor() {
        toast.view.textColor = YDSColor(name: "gray_900_c_i")
        // TODO: 배경에 대한 YDSColor에 아직 정의 되어 있지 않아 임시로 넣어 둠
        // toast.view.backgroundColor = YDSColor(name: "foobar")
        // - light: #000000 0.9
        // - dark:  #ffffff 0.9
        toast.view.backgroundColor = YDSColor(name: "gray_900_c").withAlphaComponent(0.9)
    }
    
    func configureAttributes(text: String) {
        let font = UIFont.systemFont(ofSize: 14.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 19
        paragraphStyle.alignment = .center
        
        let attrs: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraphStyle]
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes(attrs, range: NSMakeRange(0, attributedString.length))
        
        toast.view.attributedText = attributedString
    }
    
    func configureOffset(in view: UIView?) {
        toast.view.layoutSubviews()
        
        let mainRect = UIScreen.main.bounds
        let toastHeight = toast.view.bounds.height
        var bottomOffset: CGFloat = 0.0
        
        if let view {
            toast.view.useSafeAreaForBottomOffset = false
            let targetRect = view.convert(view.bounds, to: UIView(frame: mainRect))
            
            bottomOffset += mainRect.height
            bottomOffset -= targetRect.midY
            bottomOffset -= toastHeight / 2
        } else {
            toast.view.useSafeAreaForBottomOffset = true
            bottomOffset += (mainRect.height - toastHeight) / 2
        }
        
        toast.view.bottomOffsetPortrait = bottomOffset
        toast.view.bottomOffsetLandscape = bottomOffset
        configureCornerRadius(toastHeight)
    }
    
    func configureCornerRadius(_ height: CGFloat) {
        toast.view.cornerRadius = min(height / 2, 28)
    }
}
