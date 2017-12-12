//
//  OptionsView.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 06.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class OptionsView: UIView {

    @IBOutlet var optionsView: UIView!
    @IBOutlet var newTaskButton: UIButton!
    @IBOutlet var newGroupButton: UIButton!
    @IBOutlet var newNoteButton: UIButton!
    @IBOutlet var newTagButton: UIButton!
    
    var buttons: [UIButton]!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let nib = UINib(nibName: "OptionsView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        buttons = [newTaskButton, newGroupButton, newNoteButton, newTagButton]
        addSubview(optionsView)
        optionsView.frame = self.bounds
        optionsView.layer.cornerRadius = 3
    }

}
