//
//  AddTagsView.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 09.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class AddTagsView: UIView {
    
    @IBOutlet var addTagsView: UIView!
    @IBOutlet var title: UILabel!
    @IBOutlet var addTagsLabel: UILabel!
    @IBOutlet var tV: UITableView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let nib = UINib(nibName: "AddTagsView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(addTagsView)
        addTagsView.frame = self.bounds
    }

}
