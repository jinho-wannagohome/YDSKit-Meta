//
//  LabelButtonViewController.swift
//  YDSKit_Example
//
//  Created by 신범철(Shin, Beomcheol) on 2022/02/24.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

public final class LabelButtonViewController: UITableViewController {

    @IBOutlet private var containedLabelButton: Contained40LabelButton!
    @IBOutlet private var containedRightIconLabelButton: Contained40LabelButton!
    @IBOutlet private var containedLeftIconLabelButton: Contained40LabelButton!

    @IBOutlet private var containedLabelDisabledButton: Contained40LabelButton!
    @IBOutlet private var containedRightIconLabelDisabledButton: Contained40LabelButton!
    @IBOutlet private var containedLeftIconLabelDisabledButton: Contained40LabelButton!

    @IBOutlet private var outlinedLabelButton: Outlined40LabelButton!
    @IBOutlet private var outlinedRightIconLabelButton: Outlined40LabelButton!
    @IBOutlet private var outlinedLeftIconLabelButton: Outlined40LabelButton!

    @IBOutlet private var outlinedLabelDisabledButton: Outlined40LabelButton!
    @IBOutlet private var outlinedRightIconLabelDisabledButton: Outlined40LabelButton!
    @IBOutlet private var outlinedLeftIconLabelDisabledButton: Outlined40LabelButton!

    @IBOutlet private var textLabelButton: Text40LabelButton!
    @IBOutlet private var textRightIconLabelButton: Text40LabelButton!
    @IBOutlet private var textLeftIconLabelButton: Text40LabelButton!

    @IBOutlet private var textLabelDisabledButton: Text40LabelButton!
    @IBOutlet private var textRightIconLabelDisabledButton: Text40LabelButton!
    @IBOutlet private var textLeftIconLabelDisabledButton: Text40LabelButton!

    @IBOutlet private var colorLabel: UILabel!
    @IBOutlet private var heightLabel: UILabel!

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            break
        case 1:
            let alert = UIAlertController(title: "Color", message: nil, preferredStyle: .alert)
            ["primary_a", "primary_b", "primary_a_100", "accent", "accent_100", "gray_c", "gray_100_c", ].forEach { colorText in
                let action = UIAlertAction(title: colorText, style: .default) { action in
                    self.adjustColor(colorText)
                }
                alert.addAction(action)
            }
            let cancel = UIAlertAction(title: "cancel", style: .destructive)
            alert.addAction(cancel)
            present(alert, animated: true)
        case 2:
            let alert = UIAlertController(title: "Color", message: nil, preferredStyle: .alert)
            ["56 Size", "48 Size", "40 Size", "36 Size", "32 Size", "20 Size"].forEach { heightText in
                let action = UIAlertAction(title: heightText, style: .default) { action in
                    self.adjustHeight(heightText)
                }
                alert.addAction(action)
            }
            let cancel = UIAlertAction(title: "cancel", style: .destructive)
            alert.addAction(cancel)
            present(alert, animated: true)
        case 3:
            containedLabelButton.isEnabled.toggle()
            outlinedLabelButton.isEnabled.toggle()
            textLabelButton.isEnabled.toggle()
        default:
            break
        }
    }

    private func adjustColor(_ colorText: String) {
        containedLabelButton.color = colorText
        outlinedLabelButton.color = colorText
        textLabelButton.color = colorText
        containedLeftIconLabelButton.color = colorText
        outlinedLeftIconLabelButton.color = colorText
        textLeftIconLabelButton.color = colorText
        containedRightIconLabelButton.color = colorText
        outlinedRightIconLabelButton.color = colorText
        textRightIconLabelButton.color = colorText

        containedLabelDisabledButton.color = colorText
        containedRightIconLabelDisabledButton.color = colorText
        containedLeftIconLabelDisabledButton.color = colorText
        outlinedLabelDisabledButton.color = colorText
        outlinedRightIconLabelDisabledButton.color = colorText
        outlinedLeftIconLabelDisabledButton.color = colorText
        textLabelDisabledButton.color = colorText
        textRightIconLabelDisabledButton.color = colorText
        textLeftIconLabelDisabledButton.color = colorText

        colorLabel.text = colorText
    }

    private func adjustHeight(_ heightText: String) {
        guard let heightInt = Int(heightText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else { return }
        let height = CGFloat(heightInt)
        containedLabelButton.updateHeight(height)
        outlinedLabelButton.updateHeight(height)
        textLabelButton.updateHeight(height)
        containedLeftIconLabelButton.updateHeight(height)
        outlinedLeftIconLabelButton.updateHeight(height)
        textLeftIconLabelButton.updateHeight(height)
        containedRightIconLabelButton.updateHeight(height)
        outlinedRightIconLabelButton.updateHeight(height)
        textRightIconLabelButton.updateHeight(height)

        containedLabelDisabledButton.updateHeight(height)
        containedRightIconLabelDisabledButton.updateHeight(height)
        containedLeftIconLabelDisabledButton.updateHeight(height)
        outlinedLabelDisabledButton.updateHeight(height)
        outlinedRightIconLabelDisabledButton.updateHeight(height)
        outlinedLeftIconLabelDisabledButton.updateHeight(height)
        textLabelDisabledButton.updateHeight(height)
        textRightIconLabelDisabledButton.updateHeight(height)
        textLeftIconLabelDisabledButton.updateHeight(height)

        heightLabel.text = "\(Int(height)) Size"
    }
}

#if SWIFT_PACKAGE
extension LabelButtonViewController {
    public static func initializeWithStoryBoard() -> LabelButtonViewController {
        UIStoryboard(name: "LabelButton", bundle: Bundle.module)
            .instantiateViewController(withIdentifier: "LabelButtonViewController") as! LabelButtonViewController
    }
}
#endif

private extension LabelButton {
    func updateHeight(_ height: CGFloat) {
        var style = style
        style.size = LabelButtonStyle.Size(size: height)
        setupStyle(style)
    }
}
