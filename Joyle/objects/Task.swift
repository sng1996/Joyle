//
//  Task.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 06.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class Task: NSObject {
    
    var name: String = ""
    var subtasks: [Task] = []
    var parent: Task!
    var isOpen: Bool = false
    var isFinish: Bool = false
    var date: String = ""
    var level: Int = 0
    var des: String = ""
    var note: String = ""
    var points: [String] = []
    var tags: [String] = []
    
    init(name: String){
        self.name = name
    }


}
