//
//  UITextFieldExt.swift
//  PayTest
//
//  Created by Shumakov Dmytro on 18.10.2022.
//

import UIKit
import Foundation

extension UITextField {
    
    // MARK: - Properties
    static var allowedNumberCharacters = CharacterSet(charactersIn: "0123456789.").inverted
    
    // MARK: - Methods
    
}

class NMTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
