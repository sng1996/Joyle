//
//  MenuViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 20.11.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var searchView: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var inboxCountView: UIView!
    @IBOutlet var inboxCountLabel: UILabel!
    @IBOutlet var todayCountView: UIView!
    @IBOutlet var todayCountLabel: UILabel!
    @IBOutlet var todayTimeView: UIView!
    @IBOutlet var todayTimeLabel: UILabel!
    @IBOutlet var todayIconLabel: UILabel!
    @IBOutlet var tV: UITableView!
    @IBOutlet var groupsButton: UIButton!
    @IBOutlet var tagsButton: UIButton!
    @IBOutlet var secondView: UIView!
    @IBOutlet var secondGroupsButton: UIButton!
    @IBOutlet var secondTagsButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var notificationButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var redNotificationButton: UIButton!
    
    var groupsArray: [Group] = []
    var tagsArray: [Tag] = []
    var bannerIsOpen: Bool = false
    var currentContentHeight: CGFloat!
    var currentSegmentIndex: Int = 0
    
    let colors = [
                    UIColor(red:74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0),
                    UIColor(red:217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0),
                    UIColor(red:238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0),
                    UIColor(red:231/255.0, green: 63/255.0, blue: 82/255.0, alpha: 1.0)
                 ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        let titleArrayGroups = ["Маркетинг Joyle",
                          "Мобильная разработка альбомного сервиса",
                          "Баку",
                          "Владивосток"]
        let titleArrayTags = ["Маркетинг",
                              "Покупки",
                              "Конская залупа",
                              "Поросёнок"]
        
        for i in 0..<4{
            let tag = Tag()
            tag.name = titleArrayTags[i]
            tagsArray.append(tag)
        }
        
        for i in 0..<4{
            let group = Group()
            group.name = titleArrayGroups[i]
            for j in 0..<20{
                let task = Task(name: group.name + String(j))
                group.tasks.append(task)
                tagsArray[Int(arc4random()%4)].tasks.append(task)
            }
            groupsArray.append(group)
        }
        
        setupViews()
        
    }
    
    @IBAction func openBanner(){
        
        if (bannerIsOpen){
            
        }
        else{
           
        }
        
    }
    
    @IBAction func indexChanged(sender: UIButton){
        
        switch(sender){
        case groupsButton:          groupsButton.setTitleColor(colors[0], for: .normal)
                                    secondGroupsButton.setTitleColor(colors[0], for: .normal)
                                    tagsButton.setTitleColor(colors[1], for: .normal)
                                    secondTagsButton.setTitleColor(colors[1], for: .normal)
                                    currentSegmentIndex = 0
                                    break
        case tagsButton:            groupsButton.setTitleColor(colors[1], for: .normal)
                                    secondGroupsButton.setTitleColor(colors[1], for: .normal)
                                    tagsButton.setTitleColor(colors[0], for: .normal)
                                    secondTagsButton.setTitleColor(colors[0], for: .normal)
                                    currentSegmentIndex = 1
                                    break
        case secondGroupsButton:    groupsButton.setTitleColor(colors[0], for: .normal)
                                    secondGroupsButton.setTitleColor(colors[0], for: .normal)
                                    tagsButton.setTitleColor(colors[1], for: .normal)
                                    secondTagsButton.setTitleColor(colors[1], for: .normal)
                                    currentSegmentIndex = 0
                                    break
        case secondTagsButton:      groupsButton.setTitleColor(colors[1], for: .normal)
                                    secondGroupsButton.setTitleColor(colors[1], for: .normal)
                                    tagsButton.setTitleColor(colors[0], for: .normal)
                                    secondTagsButton.setTitleColor(colors[0], for: .normal)
                                    currentSegmentIndex = 1
                                    break
        default:                    break
        }
        
        tV.reloadData()
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (currentSegmentIndex == 0){
            return checkLabelFrame(string: groupsArray[indexPath.row].name) + 20
        }
        else{
            return checkLabelFrame(string: tagsArray[indexPath.row].name) + 20
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentSegmentIndex == 0){
            return groupsArray.count
        }
        else{
            return tagsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell
        
        if (currentSegmentIndex == 0){
            cell.icon.image = UIImage(named: "folder_green")
            cell.label.text = groupsArray[indexPath.row].name
            updateLabelFrame(label: cell.label)
            cell.selectionStyle = .none
        }
        else{
            cell.icon.image = UIImage(named: "tags")
            cell.label.text = tagsArray[indexPath.row].name
            updateLabelFrame(label: cell.label)
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (tV.contentOffset.y > 217.0){
            secondView.isHidden = false
            let bottom = self.view.frame.size.height - 60.0 - (tV.contentSize.height - 217.0)
            if (bottom > 0){
                tV.contentInset.bottom = bottom
            }
            else{
                tV.contentInset.bottom = 0
            }
        }
        else{
            secondView.isHidden = true
            let bottom = self.view.frame.size.height - 60.0 - (tV.contentSize.height - 217.0)
            if (bottom > 0){
                tV.contentInset.bottom = bottom
            }
            else{
                tV.contentInset.bottom = 0
            }
        }
    }
    
}
