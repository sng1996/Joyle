//
//  MoreView.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 26.11.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class MoreView: UIView {

    @IBOutlet var moreView: UIView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var cV: UICollectionView!
    @IBOutlet var calendarButton: UIButton!
    @IBOutlet var notificationButton: UIButton!
    @IBOutlet var tagButton: UIButton!
    @IBOutlet var listButton: UIButton!
    @IBOutlet var messageButton: UIButton!
    var noteTextView: UITextView!
    var addCheckPoint: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let nib = UINib(nibName: "MoreView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(moreView)
        moreView.frame = self.bounds
        
        checkButton.layer.borderColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 1.0).cgColor
        checkButton.layer.borderWidth = 1.0
        checkButton.layer.cornerRadius = 3
        
        noteTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 280, height: 30))
        noteTextView.isScrollEnabled = false
        noteTextView.font = UIFont(name: "MuseoSansCyrl-300", size: 14)
        //noteTextView.placeholder = "Добавить заметку"
        //cV.addSubview(noteTextView)
        
        addCheckPoint = UIView(frame: CGRect(x: 0, y: noteTextView.frame.size.height + 10, width: 280, height:28))
        addCheckPoint.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
        addCheckPoint.layer.cornerRadius = 3
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 28))
        button.setImage(UIImage(named: "round_green"), for: .normal)
        let textField = UITextField(frame: CGRect(x: 24, y: 0, width: 256, height: 28))
        textField.borderStyle = .none
        textField.font = UIFont(name: "MuseoSansCyrl-300", size: 14)
        textField.placeholder = "Добавить подпункт"
        
        addCheckPoint.addSubview(button)
        addCheckPoint.addSubview(textField)
        
        //cV.addSubview(addCheckPoint)
        
        
        
    }
}
