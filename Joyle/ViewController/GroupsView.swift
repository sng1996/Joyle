//
//  GroupsView.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 25.11.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class GroupsView: UIView {
    
    @IBOutlet var groupsView: UIView!
    @IBOutlet var tV: UITableView!
    @IBOutlet var label: UILabel!
    @IBOutlet var button: UIButton!
    @IBOutlet var replace_label: UILabel!
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let nib = UINib(nibName: "GroupsView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(groupsView)
        groupsView.frame = self.bounds
        button.layer.borderColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 1.0).cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 3
    }
    
}
