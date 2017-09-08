//
//  Task.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 06.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class Task: NSObject {
    
    var name: String!
    var subtasks: [Task] = []
    var isOpen: Bool = false
    
    init(name: String){
        self.name = name
    }


}
