//
//  TextFieldViewController.swift
//  YDSKit
//
//  Created by Gilwoo Hwang on 2022/07/18.
//

import UIKit

public final class TextFieldViewController: UITableViewController {

    @IBOutlet private var textField1: TextField!

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
            case 0:
                break
            case 1:
                let alert = UIAlertController(title: "Outlined", message: nil, preferredStyle: .alert)
                ["Outlined", "Contained"]
                    .forEach { outlined in
                        let action = UIAlertAction(title: outlined, style: .default) { action in
                            self.adjustOutline(outlined)
                        }
                        alert.addAction(action)
                    }
                let cancel = UIAlertAction(title: "cancel", style: .destructive)
                alert.addAction(cancel)
                present(alert, animated: true)
            case 2:
                let alert = UIAlertController(title: "Type", message: nil, preferredStyle: .alert)
                ["Text", "Password", "Search", "Certified"]
                    .forEach { type in
                        let action = UIAlertAction(title: type, style: .default) { action in
                            self.adjustType(type)
                        }
                        alert.addAction(action)
                    }
                let cancel = UIAlertAction(title: "cancel", style: .destructive)
                alert.addAction(cancel)
                present(alert, animated: true)
            case 3:
                let alert = UIAlertController(title: "Height", message: nil, preferredStyle: .alert)
                ["64 Size", "56 Size", "48-Big Size", "48-Small Size", "40 Size"]
                    .forEach { heightText in
                        let action = UIAlertAction(title: heightText, style: .default) { action in
                            self.adjustHeight(heightText)
                        }
                        alert.addAction(action)
                    }
                let cancel = UIAlertAction(title: "cancel", style: .destructive)
                alert.addAction(cancel)
                present(alert, animated: true)
            case 4:
                textField1.isEnabled.toggle()
            case 5:
                showAlertTextField(title: "suffix")
            case 6:
                showAlertTextField(title: "label")
            case 7:
                showAlertTextField(title: "help")
            case 8:
                showAlertTextField(title: "error")
            default:
                break
        }
    }

    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case 0:
                let style1 = textField1.estimateHeight
                return style1 + 60
            default:
            return UITableView.automaticDimension
        }
    }

    private func adjustOutline(_ type: String) {
        switch type {
            case "Outlined":
                update(textField: textField1, variant: .outlined)
            case "Contained":
                update(textField: textField1, variant: .contained)
            default:
                return
        }
    }

    private func adjustType(_ type: String) {
        switch type {
            case "Text":
                update(textField: textField1, contentType: .text)
            case "Password":
                update(textField: textField1, contentType: .password(secure: true))
            case "Search":
                update(textField: textField1, contentType: .search)
            case "Certified":
                update(textField: textField1, contentType: .certified)
            default:
                return
        }
    }

    private func adjustHeight(_ heightText: String) {
        let newSize: TextFieldStyle.Size
        switch heightText {
            case "64 Size":
                newSize = .h64
            case "56 Size":
                newSize = .h56
            case "48-Big Size":
                newSize = .h48Big
            case "48-Small Size":
                newSize = .h48Small
            case "40 Size":
                newSize = .h40
            default:
                return
        }
        update(textField: textField1, height: newSize)
    }

    private func addText(to: String?, text: String?) {
        guard let type = to else { return }

        switch type {
            case "suffix":
                textField1.suffix = text
            case "label":
                textField1.labelText = text
            case "help":
                textField1.helpText = text
                textField1.isError = false
                tableView.reloadData()
            case "error":
                textField1.helpText = text
                textField1.isError = true
                tableView.reloadData()
            default:
                return
        }
    }
}

#if SWIFT_PACKAGE
extension TextFieldViewController {
    public static func initializeWithStoryBoard() -> TextFieldViewController {
        UIStoryboard(name: "TextField", bundle: Bundle.module)
            .instantiateViewController(withIdentifier: "TextFieldViewController") as! TextFieldViewController
    }
}
#endif

private extension TextFieldViewController {

    func showAlertTextField(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField()

        let action = UIAlertAction(title: title, style: .default) { [unowned alert, weak self] action in
            let tf = alert.textFields![0]
            self?.addText(to: action.title, text: tf.text)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }

    func update(textField: TextField,
                variant: ColorStatementedVariant? = nil,
                contentType: TextFieldStyle.ContentsType? = nil,
                height: TextFieldStyle.Size? = nil) {
        if let variant = variant {
            var style = textField.style
            style.variant = variant
            textField.setupStyle(style)
        }

        if let height = height {
            var style = textField.style
            style.size = height
            textField.setupStyle(style)
            view.endEditing(true)
            tableView.reloadData()
        }

        if let contentType = contentType {
            var style = textField.style
            style.contentsType = contentType
            textField.setupStyle(style)

            if case .certified = contentType {
                textField.startTimer()
            }
        }
    }
}
