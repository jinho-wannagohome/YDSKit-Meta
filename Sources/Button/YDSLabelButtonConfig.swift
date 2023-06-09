//
//  YDSLabelButtonConfig.swift
//  YDSKit
//
//  Created by 임수용(Lim, SuYong) on 2021/12/07.
//

import UIKit.UIColor

final public class YDSLabelButtonConfig {
    public var disabledBorderColor: UIColor = UIColor.button_border_disabled
    public var disabledOverlayColor: UIColor = UIColor.button_overlay_disabled
    public var highlightedOverlayColor: UIColor = UIColor.button_overlay_k_pressed
    public var disabledTextColor: UIColor = UIColor.button_textcolor_disabled
}

extension UIColor {
    static public var button_border_disabled: UIColor { UIColor(red: 0, green: 0, blue: 0, alpha: 0.1) }
    static public var button_overlay_disabled: UIColor { UIColor(red: 0, green: 0, blue: 0, alpha: 0.4) }
    static public var button_overlay_k_pressed: UIColor { UIColor(red: 0, green: 0, blue: 0, alpha: 0.1) }
    static public var button_textcolor_disabled: UIColor { UIColor(red: 0, green: 0, blue: 0, alpha: 0.9) }
}
