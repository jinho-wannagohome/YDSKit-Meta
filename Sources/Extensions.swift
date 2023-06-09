//
//  Extensions.swift
//  YDSKit
//
//  Created by 신범철(Shin, Beomcheol) on 2022/02/23.
//

import UIKit

extension UILabel {

    var titleSize: CGSize {
        guard let text = text else { return .zero }
        return text.size(withAttributes: [.font: font])
    }
}

extension UIColor {

    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }

    var isWhite: Bool { redValue == 1 && greenValue == 1 && blueValue == 1 }
    var redValue: CGFloat { return CIColor(color: self).red }
    var greenValue: CGFloat { return CIColor(color: self).green }
    var blueValue: CGFloat { return CIColor(color: self).blue }
    var alphaValue: CGFloat { return CIColor(color: self).alpha }
}


extension UIView {

    var widthConstraint: CGFloat {
        get {
            var width: CGFloat = 0
            for constarint in constraints where constarint.firstAttribute == .width {
                width = constarint.constant
            }
            return width
        }
        set {
            for constarint in constraints where constarint.firstAttribute == .width {
                constarint.constant = newValue
            }
        }
    }

    func removeWidthHeightConstraints() {
        removeConstraints(constraints.filter {
            $0.firstAttribute == .width || $0.firstAttribute == .height
        })
    }

    func removePositionConstraints() {
        removeConstraints(constraints.filter {
            $0.firstAttribute == .top ||
            $0.firstAttribute == .right ||
            $0.firstAttribute == .trailing ||
            $0.firstAttribute == .bottom ||
            $0.firstAttribute == .left ||
            $0.firstAttribute == .leading ||
            $0.firstAttribute == .centerX ||
            $0.firstAttribute == .centerY
        })
    }

    func makeSize(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation = .equal, constant: CGFloat) {
        guard attribute == .width || attribute == .height else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(
            item: self,
            attribute: attribute,
            relatedBy: relation,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: constant
        ).isActive = true
    }

    func makeCenter(_ attribute: NSLayoutConstraint.Attribute? = nil, to view: UIView?) {
        guard let view = view else { return }
        var attributes: [NSLayoutConstraint.Attribute] = []
        if let attr = attribute {
            attributes.append(attr)
        } else {
            attributes.append(contentsOf: [.centerX, .centerY])
        }
        attributes
            .filter { $0 == .centerX || $0 == .centerY }
            .forEach {
                translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint(
                    item: self,
                    attribute: $0,
                    relatedBy: .equal,
                    toItem: view,
                    attribute: $0,
                    multiplier: 1,
                    constant: 0
                ).isActive = true
            }
    }

    func makeEdge(relatedBy relation: NSLayoutConstraint.Relation = .equal) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        [
            NSLayoutConstraint.Attribute.top,
            NSLayoutConstraint.Attribute.right,
            NSLayoutConstraint.Attribute.bottom,
            NSLayoutConstraint.Attribute.left
        ].forEach {
            NSLayoutConstraint(
                item: self,
                attribute: $0,
                relatedBy: relation,
                toItem: superview,
                attribute: $0,
                multiplier: 1,
                constant: 0
            ).isActive = true
        }
    }
}

extension UIImage {

    func resize(to targetSize: CGSize) -> UIImage {
        let image = self
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
