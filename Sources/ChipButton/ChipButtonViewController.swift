//
//  ChipButtonViewController.swift
//  YDSKit_Example
//
//  Created by 신범철(Shin, Beomcheol) on 2022/02/24.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

public final class ChipButtonViewController: UITableViewController {

    @IBOutlet private var containedChipButton: Contained40ChipButton!
    @IBOutlet private var outlinedChipButton: Outlined40ChipButton!
    @IBOutlet private var textChipButton: Text40ChipButton!
    @IBOutlet private var containedLeftIconChipButton: Contained40ChipButton!
    @IBOutlet private var outlinedLeftIconChipButton: Outlined40ChipButton!
    @IBOutlet private var textLeftIconChipButton: Text40ChipButton!
    @IBOutlet private var containedRightIconChipButton: Contained40ChipButton!
    @IBOutlet private var outlinedRightIconChipButton: Outlined40ChipButton!
    @IBOutlet private var textRightIconChipButton: Text40ChipButton!
    @IBOutlet private var disabledContainedChipButton: Contained40ChipButton!
    @IBOutlet private var disabledOutlinedChipButton: Outlined40ChipButton!
    @IBOutlet private var disabledTextChipButton: Text40ChipButton!
    @IBOutlet private var colorLabel: UILabel!
    @IBOutlet private var heightLabel: UILabel!
    @IBOutlet private var iconLabel: UILabel!

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            break
        case 1:
            let alert = UIAlertController(title: "Color", message: nil, preferredStyle: .alert)
            ["gray_c", "gray_900_c_i", "primary_a", "primary_b", "primary_a_100", "accent", "accent_100"].forEach { colorText in
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
            ["40 Size", "36 Size", "32 Size", "20 Size"].forEach { heightText in
                let action = UIAlertAction(title: heightText, style: .default) { action in
                    self.adjustHeight(heightText)
                }
                alert.addAction(action)
            }
            let cancel = UIAlertAction(title: "cancel", style: .destructive)
            alert.addAction(cancel)
            present(alert, animated: true)
        case 3:
            let alert = UIAlertController(title: "Color", message: nil, preferredStyle: .alert)
            ["nil", "ic_ygy_storedatail_popular", "ic_mart_categoryall_arrowdown_l_gray"].forEach { icon in
                let action = UIAlertAction(title: icon, style: .default) { action in
                    self.adjustIcon(icon)
                }
                alert.addAction(action)
            }
            let cancel = UIAlertAction(title: "cancel", style: .destructive)
            alert.addAction(cancel)
            present(alert, animated: true)
        default:
            break
        }
    }

    private func adjustColor(_ colorText: String) {
        containedChipButton.color = colorText
        outlinedChipButton.color = colorText
        textChipButton.color = colorText
        containedLeftIconChipButton.color = colorText
        outlinedLeftIconChipButton.color = colorText
        textLeftIconChipButton.color = colorText
        containedRightIconChipButton.color = colorText
        outlinedRightIconChipButton.color = colorText
        textRightIconChipButton.color = colorText
        colorLabel.text = colorText
    }

    private func adjustHeight(_ heightText: String) {
        guard let heightInt = Int(heightText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else { return }
        let height = CGFloat(heightInt)
        containedChipButton.updateHeight(height)
        outlinedChipButton.updateHeight(height)
        textChipButton.updateHeight(height)
        containedLeftIconChipButton.updateHeight(height)
        outlinedLeftIconChipButton.updateHeight(height)
        textLeftIconChipButton.updateHeight(height)
        containedRightIconChipButton.updateHeight(height)
        outlinedRightIconChipButton.updateHeight(height)
        textRightIconChipButton.updateHeight(height)
        disabledContainedChipButton.updateHeight(height)
        disabledOutlinedChipButton.updateHeight(height)
        disabledTextChipButton.updateHeight(height)
        heightLabel.text = "\(Int(height)) Size"
    }

    private func adjustIcon(_ name: String) {
        let icon = UIImage(named: name)
        containedChipButton.setImage(icon, for: .normal)
        outlinedChipButton.setImage(icon, for: .normal)
        textChipButton.setImage(icon, for: .normal)
        iconLabel.text = name
    }
}

#if SWIFT_PACKAGE
extension ChipButtonViewController {
    public static func initializeWithStoryBoard() -> ChipButtonViewController {
        UIStoryboard(name: "ChipButton", bundle: Bundle.module)
            .instantiateViewController(withIdentifier: "ChipButtonViewController") as! ChipButtonViewController
    }
}
#endif

private extension ChipButton {
    func updateHeight(_ height: CGFloat) {
        var style = style
        style.height = ChipButtonStyle.Height(height: height)
        setupStyle(style)
    }
}
