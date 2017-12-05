//
//  MainViewControllerDesign.swift
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
    }
    
    func changeNotificationButton(isRed: Bool){
        
        if (isRed){
            redNotificationButton.isHidden = false
        }
        else{
            redNotificationButton.isHidden = true
        }
        
    }

}
