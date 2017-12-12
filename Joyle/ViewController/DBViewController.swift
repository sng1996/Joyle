//
//  DBViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 12.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit
import SQLite

extension ViewController {

    func createTable_tasks(){
        
        let createTable = self.tasksTable.create{ (table) in
            table.column(self.id_tasks, primaryKey: true)
            table.column(self.name_tasks)
            table.column(self.description_tasks)
            table.column(self.date_tasks)
            table.column(self.creator_id_tasks)
        }
        
        do{ try database.run(createTable)  }catch{print(error)}
        
    }
    
    func insert_tasks(_task: Task){
        
        let insertTask = self.tasksTable.insert(self.id_tasks <- _task.task_id, self.name_tasks <- _task.name, self.description_tasks <- _task.des, self.date_tasks <- _task.date, self.creator_id_tasks <- _task.creator_id)
        
        do{ try database.run(insertTask)  }catch{print(error)}
        
    }
    
    /*func list_tasks(){
        groupsArray.removeAll()
        do{
            let groups = try self.database.prepare(self.groupsTable)
            for group in groups{
                let myGroup = Group()
                myGroup.id = group[self.id_groups]
                myGroup.name = group[self.name_groups]
                myGroup.user_id = group[self.user_id_groups]
                groupsArray.append(myGroup)
            }
        }
        catch{
            print(error)
        }
        
    }*/
    
    func getElem_tasks(_task: Task){
        
        do{
            let filterTasks = self.tasksTable.filter(self.id_tasks == _task.task_id)
            let currentTask = try database.pluck(filterTasks)
            _task.name = currentTask![self.name_tasks]
            _task.des = currentTask![self.description_tasks]
            _task.date = currentTask![self.date_tasks]
        }
        catch{
            print(error)
        }
        
    }
    
    func update_tasks(_task: Task){
        
        let currentTask = self.tasksTable.filter(self.id_tasks == _task.task_id)
        let updateTask = currentTask.update(self.name_tasks <- _task.name)
        do{ try database.run(updateTask)  } catch{print(error)}
        
    }
    
    func delete_tasks(_task: Task){
        
        let currentTask = self.tasksTable.filter(self.id_tasks == _task.task_id)
        let deleteTask = currentTask.delete()
        do{ try database.run(deleteTask)  }catch{print(error)}
        
    }
    
    func truncateTable_tasks(){
        
        let dropTable = self.tasksTable.drop()
        do{ try database.run(dropTable)  }catch{print(error)}
        createTable_tasks()
        
    }
    
    func createTable_task_items(){
        
        let createTable = self.task_itemsTable.create{ (table) in
            table.column(self.id_task_items, primaryKey: true)
            table.column(self.task_id_task_items)
            table.column(self.group_id_task_items)
            table.column(self.parent_id_task_items)
            table.column(self.is_open_task_items)
            table.column(self.priority_task_items)
            table.column(self.delegated_to_user_id_task_items)
            table.column(self.delegated_from_user_id_task_items)
            table.column(self.position_task_items)
        }
        
        do{ try database.run(createTable)  }catch{print(error)}
        
    }
    
    func insert_task_items(_task: Task){
        
        let insertTask_item = self.task_itemsTable.insert(self.id_task_items <- _task.task_item_id, self.task_id_task_items <- _task.task_id, self.group_id_task_items <- _task.group_id, self.parent_id_task_items <- _task.parent_id, self.is_open_task_items <- _task.isOpen, self.priority_task_items <- _task.priority, self.delegated_to_user_id_task_items <- _task.delegated_to_user_id, self.delegated_from_user_id_task_items <- _task.delegated_from_user_id, self.position_task_items <- _task.position)
        
        do{ try database.run(insertTask_item)  }catch{print(error)}
        
    }
    
    func list_task_items(){
        allTasks.removeAll()
        for _group in groups{
            _group.tasks.removeAll()
        }
        do{
            let task_items = try database.prepare(self.task_itemsTable)
            for task_item in task_items{
                let myTask = Task()
                myTask.task_item_id = task_item[self.id_task_items]
                myTask.task_id = task_item[self.task_id_task_items]
                myTask.group_id = task_item[self.group_id_task_items]
                myTask.parent_id = task_item[self.parent_id_task_items]
                myTask.priority = task_item[self.priority_task_items]
                myTask.isOpen = task_item[self.is_open_task_items]
                myTask.delegated_to_user_id = task_item[self.delegated_to_user_id_task_items]
                myTask.delegated_from_user_id = task_item[self.delegated_from_user_id_task_items]
                myTask.position = task_item[self.position_task_items]
                allTasks.append(myTask)
            }
        }
        catch{
            print(error)
        }
        for myTask in allTasks{
            myTask.subtasks.removeAll()
            getElem_tasks(_task: myTask)
            print("TASK NAME: " + myTask.name)
            if (myTask.parent_id == ""){
                for _group in groups{
                    if (_group.id == myTask.group_id){
                        print("GROUP NAME: " + _group.name)
                        myTask.group = _group
                        _group.tasks.append(myTask)
                        break
                    }
                }
                continue
            }
            for _task in allTasks{
                if (myTask.parent_id == _task.task_item_id){
                    myTask.parent = _task
                    _task.subtasks.append(myTask)
                    break
                }
            }
        }
        
    }
    
    func update_task_items(_task: Task){
        
        /*let currentTask = self.tasksTable.filter(self.id_tasks == _task.id)
        let updateTask = currentTask.update(self.name_tasks <- _task.name)
        do{ try database.run(updateTask)  } catch{print(error)}*/
        
    }
    
    func delete_task_items(_task: Task){
        
        /*let currentTask = self.tasksTable.filter(self.id_tasks == _task.id)
        let deleteTask = currentTask.delete()
        do{ try database.run(deleteTask)  }catch{print(error)}*/
        
    }
    
    func truncateTable_task_items(){
        
        let dropTable = self.task_itemsTable.drop()
        do{ try database.run(dropTable)  }catch{print(error)}
        createTable_task_items()
        
    }
    
}
