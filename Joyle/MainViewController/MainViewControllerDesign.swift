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
        label.font = UIFont(name: "MuseoSansCyrl-300", size: 14)
        label.text = string
        label.numberOfLines = 3
        let maxSize = CGSize(width: 232, height: 100)
        let size = label.sizeThatFits(maxSize)
        return size.height
    }

}
