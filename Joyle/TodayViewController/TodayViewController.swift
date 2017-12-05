//
//  TodayViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 04.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    
    @IBOutlet var cV: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let todayTaskCellNib = UINib(nibName: "TodayTaskCell", bundle: nil)
        cV.register(todayTaskCellNib, forCellWithReuseIdentifier: "todayTaskCell")
        
        let todayTitleCellNib = UINib(nibName: "TodayTitleCell", bundle: nil)
        cV.register(todayTitleCellNib, forCellWithReuseIdentifier: "todayTitleCell")
        
    }

}
