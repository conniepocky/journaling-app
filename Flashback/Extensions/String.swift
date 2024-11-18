//
//  String.swift
//  Flashback
//
//  Created by Connie Waffles on 31/07/2023.
//

import SwiftUI
import UIKit

extension String {
    func before(first delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            let before = prefix(upTo: index)
            return String(before)
        }
        return ""
    }
    
    func after(first delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            let after = suffix(from: index).dropFirst()
            return String(after)
        }
        return ""
    }
    
    var isValidName: Bool {
       let RegEx = "\\w{1,20}"
       let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
       return Test.evaluate(with: self)
    }
}

extension UIViewController{
    
    public func showAlertMessage(title: String, message: String){
        
        let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        alertMessagePopUpBox.addAction(okButton)
        self.present(alertMessagePopUpBox, animated: true)
    }
}
