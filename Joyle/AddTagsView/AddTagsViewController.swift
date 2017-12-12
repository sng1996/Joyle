//
//  AddTagsViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 09.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class AddTagsViewController: UIViewController {
    
    @IBOutlet var addTagsView: AddTagsView!
    var tags: [Tag] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleArrayTags = ["Маркетинг",
                              "Покупки",
                              "Конская залупа",
                              "Поросёнок"]
        
        for i in 0..<4{
            let tag = Tag()
            tag.name = titleArrayTags[i]
            tags.append(tag)
        }

        let tagCellNib = UINib(nibName: "TagCell", bundle: nil)
        addTagsView.tV.register(tagCellNib, forCellReuseIdentifier: "tagCell")
        addTagsView.tV.delegate = self
        addTagsView.tV.dataSource = self
        
    }
    
    func changeStatus(sender: UIButton){
        
        let cell = sender.superview as! TagCell
        let indexPath = addTagsView.tV.indexPath(for: cell)
        if tags[(indexPath?.row)!].isActive{
            cell.tagImageView.image = #imageLiteral(resourceName: "tags_gray")
            cell.checkButton.setImage(#imageLiteral(resourceName: "checkbox_gray"), for: .normal)
            tags[(indexPath?.row)!].isActive = false
        }
        else{
            cell.tagImageView.image = #imageLiteral(resourceName: "tags")
            cell.checkButton.setImage(#imageLiteral(resourceName: "checkbox_green"), for: .normal)
            tags[(indexPath?.row)!].isActive = true
        }
        
    }

    
}

extension AddTagsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! TagCell
        if (tags[indexPath.row].isActive){
            cell.tagImageView.image = #imageLiteral(resourceName: "tags")
            cell.checkButton.setImage(#imageLiteral(resourceName: "checkbox_green"), for: .normal)
            
        }
        else{
            cell.tagImageView.image = #imageLiteral(resourceName: "tags_gray")
            cell.checkButton.setImage(#imageLiteral(resourceName: "checkbox_gray"), for: .normal)
        }
        
        cell.name.text = tags[indexPath.row].name
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! TagCell
        
        if tags[(indexPath.row)].isActive{
            cell.tagImageView.image = #imageLiteral(resourceName: "tags_gray")
            cell.checkButton.setImage(#imageLiteral(resourceName: "checkbox_gray"), for: .normal)
            tags[(indexPath.row)].isActive = false
        }
        else{
            cell.tagImageView.image = #imageLiteral(resourceName: "tags")
            cell.checkButton.setImage(#imageLiteral(resourceName: "checkbox_green"), for: .normal)
            tags[(indexPath.row)].isActive = true
        }
        
    }
    
}
