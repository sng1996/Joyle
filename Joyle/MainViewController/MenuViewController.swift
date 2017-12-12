//
//  MenuViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 20.11.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit
import SQLite

class MenuViewController: UIViewController, UITextFieldDelegate {

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
    @IBOutlet var optionsView: OptionsView!
    @IBOutlet var backBannerButton: UIButton!
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var panelView: UIView!
    
    //DB
    var database: Connection!
    //groups
    let groupsTable = Table("groups")
    let id_groups = Expression<String>("id")
    let name_groups = Expression<String>("name")
    let user_id_groups = Expression<String>("user_id")
    //tags
    let tagsTable = Table("tags")
    let id_tags = Expression<String>("id")
    let name_tags = Expression<String>("name")
    let user_id_tags = Expression<String>("user_id")
    
    var groupsArray: [Group] = []
    var tagsArray: [Tag] = []
    var inbox: Group!
    var currentContentHeight: CGFloat!
    var currentSegmentIndex: Int = 0
    var newElement: Int = 0
    var myKeyboardHeight: CGFloat = 0.0
    var isNeedToOffset: Bool = false
    var isKeyboardOpen: Bool = false
    
    let colors = [
                    UIColor(red:74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0),
                    UIColor(red:217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0),
                    UIColor(red:238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0),
                    UIColor(red:231/255.0, green: 63/255.0, blue: 82/255.0, alpha: 1.0)
                 ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        setupDB()
        addButtonTargets()
        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        createTable_groups()
        createTable_tags()
        updateData_groups()
        updateData_tags()
        getGroups_API()
        getTags_API()
        
    }
    
    @IBAction func openBanner(){

        optionsView.isHidden = false
        backBannerButton.isHidden = false
        
    }
    
    @IBAction func closeBanner(){
        
        optionsView.isHidden = true
        backBannerButton.isHidden = true
        
    }
    
    func activeNewElement(sender: UIButton){
        
        newElement = sender.tag
        tV.contentOffset.y = 100.0
        if (newElement == 1){
            activeSegment(isGroups: true)
        }
        if (newElement == 3){
            activeSegment(isGroups: false)
        }
        tV.reloadData()
        optionsView.isHidden = true
        backBannerButton.isHidden = true
        
    }
    
    @IBAction func indexChanged(sender: UIButton){
        
        switch(sender){
        case groupsButton:          activeSegment(isGroups: true)
                                    break
        case tagsButton:            activeSegment(isGroups: false)
                                    break
        case secondGroupsButton:    activeSegment(isGroups: true)
                                    break
        case secondTagsButton:      activeSegment(isGroups: false)
                                    break
        default:                    break
        }
        
        tV.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if (textField.text?.isEmpty)!{
        }
        else{
            if (newElement == 1){
                createGroup(name: textField.text!)
            }
            if (newElement == 3){
                createTag(name: textField.text!)
            }
        }
        newElement = 0
        tV.reloadData()
        return false
    }
    
    func keyBoardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            myKeyboardHeight = keyboardHeight
        }
        isKeyboardOpen = true
    }
    
    func keyBoardWillHide(notification: NSNotification) {
        isKeyboardOpen = false
    }

}
