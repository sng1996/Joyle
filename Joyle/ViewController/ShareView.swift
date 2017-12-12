//
//  ShareView.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 10.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class ShareView: UIView {

    @IBOutlet var shareView: UIView!
    @IBOutlet var titleView: UIView!
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var emailView: UIView!
    @IBOutlet var emailImageView: UIImageView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var tV: UITableView!
    @IBOutlet var copyLinkButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let nib = UINib(nibName: "ShareView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(shareView)
        shareView.frame = self.bounds
        
        emailView.layer.cornerRadius = 20
        emailView.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        emailView.layer.borderWidth = 1
        
        copyLinkButton.layer.cornerRadius = 20
        copyLinkButton.layer.borderColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        copyLinkButton.layer.borderWidth = 1
    }
    

}
