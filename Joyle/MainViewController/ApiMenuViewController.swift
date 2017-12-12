//
//  ApiMenuViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 10.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

extension MenuViewController{

    func getGroups_API(){
        let string = "https://api.joyle.evilcap.ru/api/groups"
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
                    self.truncateTable_groups()
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let groups = json["groups"] as? [[String: Any]]
                    for elem in groups!{
                        let group = elem as NSDictionary?
                        let myGroup = Group()
                        myGroup.id = group!["id"] as! String
                        myGroup.name = group!["name"] as! String
                        myGroup.user_id = group!["user_id"] as! String
                        let task_item_ids = group!["task_item_ids"]  as? [String]
                        for task_item_id in task_item_ids!{
                            myGroup.task_item_ids.append(task_item_id)
                        }
                        //self.groupsArray.append(myGroup)
                        self.insert_groups(_group: myGroup)
                    }
                    OperationQueue.main.addOperation({
                        self.updateData_groups()
                    })
                    
                }catch let error as NSError{
                    //print(error)
                }
            }
        }
        mySession.resume()
        
    }
    
    func createGroup_API(name: String){
        
        let url = URL(string: "https://api.joyle.evilcap.ru/api/groups")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Token token=iZFxVVKycye46Xyfwfzz", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let params = ["name":name, "user_id":"5a2d2e9c2c706b0f21d77e2d"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            //print("responseString = \(responseString)")
            OperationQueue.main.addOperation({
                
            })
        }
        task.resume()
        
    }
    
    func getTags_API(){
        
        let string = "https://api.joyle.evilcap.ru/api/tags"
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
                    self.truncateTable_tags()
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let tags = json["tags"] as? [[String: Any]]
                    for elem in tags!{
                        let tag = elem as NSDictionary?
                        let myTag = Tag()
                        myTag.id = tag!["id"] as! String
                        myTag.name = tag!["name"] as! String
                        myTag.user_id = tag!["user_id"] as! String
                        let tag_item_ids = tag!["tag_item_ids"]  as? [String]
                        for tag_item_id in tag_item_ids!{
                            myTag.tag_item_ids.append(tag_item_id)
                        }
                        //self.tagsArray.append(myTag)
                        self.insert_tags(_tag: myTag)
                    }
                    OperationQueue.main.addOperation({
                        self.updateData_tags()
                    })
                    
                }catch let error as NSError{
                    //print(error)
                }
            }
        }
        mySession.resume()
        
    }
    
    func createTag_API(name: String){
        
        let url = URL(string: "https://api.joyle.evilcap.ru/api/tags")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Token token=iZFxVVKycye46Xyfwfzz", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let params = ["name":name, "user_id":"5a2d2e9c2c706b0f21d77e2d"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                //print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            //print("responseString = \(responseString)")
            OperationQueue.main.addOperation({
                
            })
        }
        task.resume()
        
    }
    
}
