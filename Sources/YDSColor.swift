//
//  YDSColor.swift
//  YDSKit
//
//  Created by Masher Shin on 2022/02/19.
//

import UIKit

public class YDSColor: UIColor {

    public convenience init(name: String) {
        self.init(named: name, in: Bundle(for: YDSColor.self), compatibleWith: nil)!
        self.accessibilityLabel = name
    }

    public convenience init?(hasName name: String) {
        self.init(named: name.removedNumeric, in: Bundle(for: YDSColor.self), compatibleWith: nil)
        self.accessibilityLabel = name
    }

    struct ContentsVariant {

        private var color: YDSColor

        init(_ color: YDSColor) {
            Bundle.module
            self.color = color
        }

        var contained: YDSColor {
            return color.isFoundation ? color.contrastColor : color.foundation
        }

        var outlined: YDSColor {
            if color.isWhite { return YDSColor(name: "gray_800_c") }
            return color.isFoundation ? color : color.foundation
        }
    }
}

extension YDSColor { // UIColor를 상속받은경우 추가 프로퍼티를 반드시 extension에 명시해야함

    var contents: ContentsVariant {
        ContentsVariant(self)
    }

    var overlayPressed: UIColor {
        if foundation.isWhite {
            return foundation.withAlphaComponent(0.2)
        } else {
            return foundation.withAlphaComponent(0.1)
        }
    }
    
    var isFoundation: Bool {
        guard let name = accessibilityLabel else { return false }
        if name == name.removedNumeric {
            return true
        } else {
            return false
        }
    }
}

private extension YDSColor {

    var foundation: YDSColor {
        guard let name = accessibilityLabel else { return self }
        if name == name.foundation {
            return self
        } else {
            return YDSColor(hasName: name.foundation) ?? YDSColor(name: name)
        }
    }

    var isInversed: Bool {
        guard let name = accessibilityLabel else { return false }
        return name.suffix(2) == "_i"
    }

    var contrastColor: YDSColor {
        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))

        return luminance < 0.5
        ? YDSColor(red: 0, green: 0, blue: 0, alpha: 1)
        : YDSColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
}

fileprivate extension String {
    var isNumber: Bool {
        !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

    var removedNumeric: String {
        split(separator: "_")
            .filter { String($0).isNumber == false }
            .joined(separator: "_")
    }

    var removedInverse: String {
        var string = self
        if string.hasSuffix("_i") {
            string.removeLast(2)
        }
        return string
    }

    var foundation: String {
        var string = self
        string = string.removedNumeric
        string = string.removedInverse
        return string
    }

    func camelCaseToSnakeCase() -> String {
        let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
        let fullWordsPattern = "([a-z])([A-Z]|[0-9])"
        let digitsFirstPattern = "([0-9])([A-Z])"
        return self.processCamelCaseRegex(pattern: acronymPattern)?
            .processCamelCaseRegex(pattern: fullWordsPattern)?
            .processCamelCaseRegex(pattern:digitsFirstPattern)?.lowercased() ?? self.lowercased()
    }

    private func processCamelCaseRegex(pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
    }
}
