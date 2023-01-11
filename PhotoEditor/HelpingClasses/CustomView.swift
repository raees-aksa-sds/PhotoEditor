//
//  CustomView.swift
//  PhotoEditor
//
//  Created by Raees on 09/01/2023.
//

import Foundation
import UIKit

@IBDesignable
open class CustomView: UIView {
    // Color of border
    @IBInspectable var borderColor: UIColor = UIColor.gray {
        didSet {
            configure()
        }
    }
    // Border width
    @IBInspectable var borderWidth: Float = 0.0 {
        didSet {
            configure()
        }
    }
    // Corner radius
    @IBInspectable var cornerRadius: Float = 0.0 {
        didSet {
            configure()
        }
    }
    // MARK: -  UIView
    override open func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    // MARK: - Private methods
    fileprivate func configure() {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = CGFloat(borderWidth)
        layer.cornerRadius = CGFloat(cornerRadius)
    }
}
extension UIView {

    func takeScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}
