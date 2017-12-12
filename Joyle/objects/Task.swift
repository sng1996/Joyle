//
//  Task.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 06.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class Task: NSObject {
    
    var task_id: String = ""
    var task_item_id: String = ""
    var group_id: String = ""
    var group: Group!
    var name: String = ""
    var subtasks: [Task] = []
    var parent: Task!
    var parent_id: String = ""
    var isOpen: Bool = false
    var isFinish: Bool = false
    var date: String = ""
    var level: Int = 0
    var des: String = ""
    var note: String = ""
    var points: [String] = []
    var tags: [String] = []
    var creator_id: String = ""
    var priority: Int = 0
    var delegated_to_user_id: String = ""
    var delegated_from_user_id: String = ""
    var position: Int = 0
    
}
