//
//  TableExtensionView.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 02.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView == more_tV){
            return 28
        }
        else{
            let label = UILabel()
            label.text = groups[indexPath.row].name
            label.font = UIFont(name: "MuseoSansCyrl-300", size: 16)
            return checkLabelFrame(label: label) + 20
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == more_tV){
            if (checkPoints.count == 0 && more_tV.isHidden){
                tableView.frame.size.height = 0
                tableView.contentSize.height = CGFloat(28*checkPoints.count)
            }
            else{
                tableView.frame.size.height = CGFloat(28*(checkPoints.count+1))
                tableView.contentSize.height = CGFloat(28*checkPoints.count+1)
            }
            moveObjectsInsideScrollView()
            return checkPoints.count + 1
        }
        else{
            return groups.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == more_tV){
            if (indexPath.row == checkPoints.count){
                let cell = tableView.dequeueReusableCell(withIdentifier: "moreAddPointCell", for: indexPath) as! MoreAddPointCell
                tV_textField = cell.textField
                cell.textField.delegate = self
                cell.textField.placeholder = "Добавить подпункт"
                cell.textField.inputAccessoryView = customView
                cell.textField.inputAccessoryView?.isHidden = false
                cell.textField.reloadInputViews()
                cell.textField.becomeFirstResponder()
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath) as! MoreCell
            cell.label.text = checkPoints[indexPath.row]
            cell.checkButton.addTarget(self, action: #selector(clickCheckPoint(sender:)), for: .touchUpInside)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupsCell", for: indexPath) as! GroupsCell
            
            switch indexPath.row{
            case 0: cell.icon.image = UIImage(named: "inbox")
                break
            case 1: cell.icon.image = UIImage(named: "add_folder")
            cell.label.textColor = UIColor(red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0)
                break
            default: cell.icon.image = UIImage(named: "folder-icon")
                break
            }
            cell.label.text = groups[indexPath.row].name
            updateLabelFrame(label: cell.label)
            cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        closeGroupsView()
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        let index = sender as! Int
        if index == 1{
            deleteCheckPoint(indexPath: indexPath)
        }
    }

    
}
