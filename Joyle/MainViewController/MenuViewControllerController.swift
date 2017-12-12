//
//  MenuViewControllerController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 20.11.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

extension MenuViewController{

    func updateData_groups(){
        list_groups()
        if (groupsArray.count > 0){
            inbox = groupsArray[0]
            groupsArray.remove(at: 0)
            inboxCountLabel.text = String(inbox.task_item_ids.count)
        }
        else{
            inboxCountLabel.text = String(0)
        }
        tV.reloadData()
    }
    
    func updateData_tags(){
        list_tags()
        tV.reloadData()
    }
    
    func createGroup(name: String){
        
        createGroup_API(name: name)
        let myGroup = Group()
        myGroup.name = name
        insert_groups(_group: myGroup)
        groupsArray.insert(myGroup, at: 0)
        tV.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        
    }
    
    func createTag(name: String){
        
        createTag_API(name: name)
        let tag = Tag()
        tag.name = name
        insert_tags(_tag: tag)
        tagsArray.insert(tag, at: 0)
        tV.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        
    }

}
