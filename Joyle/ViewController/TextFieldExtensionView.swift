//
//  TextFieldExtensionView.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 02.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.text?.isEmpty)!{
            textField.inputAccessoryView?.isHidden = true
            textField.reloadInputViews()
            textField.resignFirstResponder()
        }
        else{
            addCheckPoint(textField: textField)
            
        }
        return true
        
}
}
