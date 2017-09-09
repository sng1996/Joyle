//
//  Section.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 07.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class Section: NSObject {
    
    var tasks: [Task]!
    var level: Int = 0
    
    override init(){}
    
    init(tasks: [Task], level: Int){
        self.tasks = tasks
        self.level = level
    }

}
