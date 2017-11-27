//
//  AddNotificationView.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 25.11.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class AddNotificationView: UIView {
    
    @IBOutlet var addNotificationView: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var addButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let nib = UINib(nibName: "AddNotificationView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(addNotificationView)
        addNotificationView.frame = self.bounds
        addButton.layer.borderColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0).cgColor
        addButton.layer.borderWidth = 1.0
        addNotificationView.layer.cornerRadius = 5
    }

}
