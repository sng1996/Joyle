//
//  TableMainViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 10.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

extension MenuViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (currentSegmentIndex == 0){
            if (tableView.numberOfRows(inSection: 0) == groupsArray.count + 1){
                if (indexPath.row == 0){
                    return 44.0
                }
                return checkLabelFrame(string: groupsArray[indexPath.row-1].name) + 20
            }
            return checkLabelFrame(string: groupsArray[indexPath.row].name) + 20
        }
        if (tableView.numberOfRows(inSection: 0) == tagsArray.count + 1){
            if (indexPath.row == 0){
                return 44.0
            }
            return checkLabelFrame(string: tagsArray[indexPath.row-1].name) + 20
        }
        return checkLabelFrame(string: tagsArray[indexPath.row].name) + 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentSegmentIndex == 0){
            if (newElement == 1){
                return groupsArray.count + 1
            }
            return groupsArray.count
        }
        if (newElement == 3){
            return tagsArray.count + 1
        }
        return tagsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (currentSegmentIndex == 0){
            var dif = 0
            if (tableView.numberOfRows(inSection: 0) == groupsArray.count + 1){
                if (indexPath.row == 0){
                    let newCell = tableView.dequeueReusableCell(withIdentifier: "newGroupCell", for: indexPath) as! NewGroupCell
                    newCell.myTextField.text = ""
                    newCell.myTextField.placeholder = "Новая группа"
                    newCell.myTextField.delegate = self
                    newCell.myTextField.becomeFirstResponder()
                    return newCell
                }
                dif = 1
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell
            cell.icon.image = UIImage(named: "folder_green")
            cell.label.text = groupsArray[indexPath.row - dif].name
            updateLabelFrame(label: cell.label)
            cell.selectionStyle = .none
            return cell
        }
        else{
            var dif = 0
            if (tableView.numberOfRows(inSection: 0) == tagsArray.count + 1){
                if (tableView.numberOfRows(inSection: 0) == tagsArray.count + 1 && indexPath.row == 0){
                    let newCell = tableView.dequeueReusableCell(withIdentifier: "newGroupCell", for: indexPath) as! NewGroupCell
                    newCell.myTextField.text = ""
                    newCell.myTextField.placeholder = "Новый тег"
                    newCell.myTextField.delegate = self
                    newCell.myTextField.becomeFirstResponder()
                    return newCell
                }
                dif = 1
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell
            cell.icon.image = UIImage(named: "folder_green")
            cell.label.text = tagsArray[indexPath.row - dif].name
            updateLabelFrame(label: cell.label)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        next.groupIndex = indexPath.row
        next.groups = groupsArray
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (tV.contentOffset.y > 217.0){
            secondView.isHidden = false
        }
        else{
            secondView.isHidden = true
        }
        if isKeyboardOpen{
            scrollView.contentOffset.y = 100.0
        }
    }
    
}

