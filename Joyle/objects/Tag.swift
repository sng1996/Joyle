//
//  Tag.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 05.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class Tag: NSObject {
    
    var id: String = ""
    var name: String = ""
    var tasks: [Task] = []
    var user_id: String = ""
    var tag_item_ids: [String] = []
    var isActive: Bool = false
    
}
