//
//  DesignableUITextField.swift
//  AUTOBCM
//
//  Created by vishnu jangid on 08/02/18.
//  Copyright © 2018 brsoftech. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {

    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width+16, height: image.size.height))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
    }
}


@IBDesignable extension UIView {
    @IBInspectable var borderColors: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidths: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadiuss: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}
