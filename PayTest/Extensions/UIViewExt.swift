//
//  UIViewExt.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 17.10.2022.
//

import UIKit
import Foundation

// MARK: - IBInspectable -

extension UIView {
    @IBInspectable var cornerRadiusView: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
        
    @IBInspectable var borderWidthView: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
        
    @IBInspectable var borderColorView: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIView {
    
    // MARK: - Animation
    
    func bounce(){
        
        UIView.animate(withDuration: 0.1,
        animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.identity
            }
        })
    }
}
