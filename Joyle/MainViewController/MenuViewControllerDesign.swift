//
//  MenuViewControllerDesign.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 20.11.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

extension MenuViewController{

    func updateLabelFrame(label: UILabel){
        label.numberOfLines = 3
        let maxSize = CGSize(width: 232, height: 100)
        let size = label.sizeThatFits(maxSize)
        label.frame = CGRect(origin: CGPoint(x: label.frame.origin.x, y: label.frame.origin.y), size: size)
    }
    
    func checkLabelFrame(string: String) -> CGFloat{
        let label = UILabel()
        label.font = UIFont(name: "MuseoSansCyrl-500", size: 16)
        label.text = string
        label.numberOfLines = 3
        let maxSize = CGSize(width: 232, height: 100)
        let size = label.sizeThatFits(maxSize)
        return size.height
    }
    
    func setupViews(){
        searchView.layer.cornerRadius = 4
        inboxCountView.layer.cornerRadius = 10
        todayCountView.layer.cornerRadius = 10
        todayTimeView.layer.cornerRadius = 10
        settingsButton.layer.cornerRadius = 20
        settingsButton.layer.borderColor = colors[2].cgColor
        settingsButton.layer.borderWidth = 1.0
        notificationButton.layer.cornerRadius = 20
        redNotificationButton.layer.cornerRadius = 20
        rightButton.layer.cornerRadius = 20
        optionsView.layer.cornerRadius = 3
    }
    
    func changeNotificationButton(isRed: Bool){
        
        if (isRed){
            redNotificationButton.isHidden = false
        }
        else{
            redNotificationButton.isHidden = true
        }
        
    }
    
    func addButtonTargets(){
        optionsView.buttons[1].addTarget(self, action: #selector(activeNewElement(sender:)), for: .touchUpInside)
        optionsView.buttons[3].addTarget(self, action: #selector(activeNewElement(sender:)), for: .touchUpInside)
    }
    
    func activeSegment(isGroups: Bool){
        
        if isGroups{
            groupsButton.setTitleColor(colors[0], for: .normal)
            secondGroupsButton.setTitleColor(colors[0], for: .normal)
            tagsButton.setTitleColor(colors[1], for: .normal)
            secondTagsButton.setTitleColor(colors[1], for: .normal)
            currentSegmentIndex = 0
        }
        else{
            groupsButton.setTitleColor(colors[1], for: .normal)
            secondGroupsButton.setTitleColor(colors[1], for: .normal)
            tagsButton.setTitleColor(colors[0], for: .normal)
            secondTagsButton.setTitleColor(colors[0], for: .normal)
            currentSegmentIndex = 1
        }
        
    }

}
