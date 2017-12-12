//
//  ApiViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 12.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

extension ViewController{

    func getTaskItems_API(){
        let string = "https://api.joyle.evilcap.ru/api/task_items"
        let url = URL(string: string)
        let request = NSMutableURLRequest(url: url!)
        request.setValue("Token token=iZFxVVKycye46Xyfwfzz", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let mySession = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let antwort = response as? HTTPURLResponse {
                let code = antwort.statusCode
                print(code)
            }
            if(error != nil){
                print("error")
            }else{
                do{
                    self.truncateTable_task_items()
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let task_items = json["task_items"] as? [[String: Any]]
                    for elem in task_items!{
                        let task_item = elem as NSDictionary?
                        let myTask = Task()
                        myTask.task_item_id = task_item!["id"] as! String
                        //myTask.priority = task_item!["priority"] as! Int
                        myTask.task_id = task_item!["task_id"] as! String
                        //myTask.parent_id = task_item!["parent_id"] as! String ?? ""
                        myTask.group_id = task_item!["group_id"] as! String
                        myTask.delegated_to_user_id = task_item!["delegated_to_user_id"] as! String
                        myTask.delegated_from_user_id = task_item!["delegated_from_user_id"] as! String
                        myTask.isOpen = task_item!["is_open"] as! Bool
                        myTask.position = task_item!["position"] as! Int
                        self.insert_task_items(_task: myTask)
                    }
                    OperationQueue.main.addOperation({
                        
                    })
                    
                }catch let error as NSError{
                    //print(error)
                }
            }
        }
        mySession.resume()
        
    }
    
    func getTasks_API(){
        let string = "https://api.joyle.evilcap.ru/api/tasks"
        let url = URL(string: string)
        let request = NSMutableURLRequest(url: url!)
        request.setValue("Token token=iZFxVVKycye46Xyfwfzz", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let mySession = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let antwort = response as? HTTPURLResponse {
                let code = antwort.statusCode
                print(code)
            }
            if(error != nil){
                print("error")
            }else{
                do{
                    self.truncateTable_tasks()
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let tasks = json["tasks"] as? [[String: Any]]
                    for elem in tasks!{
                        let task = elem as NSDictionary?
                        let myTask = Task()
                        myTask.task_id = task!["id"] as! String
                        myTask.name = task!["name"] as! String
                        myTask.des = task!["description"] as! String
                        //myTask.date = task!["date"] as! String
                        myTask.creator_id = task!["creator_id"] as! String
                        self.insert_tasks(_task: myTask)
                    }
                    OperationQueue.main.addOperation({
                        self.updateData_tasks()
                    })
                    
                }catch let error as NSError{
                    //print(error)
                }
            }
        }
        mySession.resume()
        
    }
    
}
