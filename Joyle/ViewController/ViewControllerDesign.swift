//
//  ViewControllerDesign.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 18.11.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

extension ViewController{
    
    func setupRectView(){
        topView.layer.cornerRadius = 3
        topLabel.text = groups[groupIndex].name
        rectView.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        rectView.backgroundColor = .white
        rectView.isHidden = true
        self.view.insertSubview(rectView, at: 0)
    }
    
    func setupBorderSublayer(){
        borderSublayer = CAShapeLayer()
        borderSublayer.strokeColor = UIColor(red: 202/255.0, green: 202/255.0, blue: 202/255.0, alpha: 1.0).cgColor
        borderSublayer.lineDashPattern = [10, 5]
        borderSublayer.frame = replaceView.bounds
        borderSublayer.fillColor = nil
        borderSublayer.path = UIBezierPath(roundedRect: replaceView.bounds, cornerRadius: 10.0).cgPath
        replaceView.layer.addSublayer(borderSublayer)
    }
    
    func setupDragView(){
        dragView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        dragView.isHidden = true
        dragView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.74)
        dragView.layer.cornerRadius = 3
        dragView.layer.shadowColor = UIColor.black.cgColor
        dragView.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
        dragView.layer.shadowOpacity = 0.15
        dragView.layer.shadowRadius = 8
        self.view.addSubview(dragView)
    }
    
    func setupDragViewButton(){
        let dragViewButton = UIButton(frame: CGRect(x: 10, y: 12, width: 14, height: 14))
        dragViewButton.layer.borderColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 1.0).cgColor
        dragViewButton.layer.borderWidth = 1.0
        dragViewButton.layer.cornerRadius = 3
        dragView.addSubview(dragViewButton)
    }
    
    func setupDragViewLabel(){
        let dragViewLabel = UILabel(frame: CGRect(x: 34, y: 11, width: 217, height: 16))
        dragViewLabel.text = "label"
        dragViewLabel.font = UIFont(name: "MuseoSansCyrl-500", size: 14)
        dragView.addSubview(dragViewLabel)
    }
    
    func setupButtons(){
        addButton.layer.cornerRadius = 20
        backButton.layer.cornerRadius = 20
    }
    
    func setupLevelViews(){
        for i in 0..<5{
            let myView = UIView(frame: CGRect(x: 10*i, y: 0, width: 300 - 10*i, height: 40))
            myView.backgroundColor = colors[i]
            myView.isHidden = true
            myView.layer.cornerRadius = 3
            rectView.addSubview(myView)
            views.append(myView)
        }
    }
    
    func changeArrow(cell: TaskCell, isOpen: Bool, isParent: Bool){
        
        if (isParent){
            cell.arrowButton.isHidden = false
        }
        else{
            cell.arrowButton.isHidden = true
        }
        
        if (isOpen){
            cell.arrowButton.setImage(UIImage(named: "downArrow"), for: .normal)
        }
        else{
            cell.arrowButton.setImage(UIImage(named: "rightArrow"), for: .normal)
        }
        
    }
    
    func setupCurrentCell(selectedIndexPath: IndexPath){
        let currentCell = cV.cellForItem(at: selectedIndexPath) as? TaskCell
        currentCell?.isHidden = true
    }
    
    func setupDroppedCell(){
        let cell = cV.cellForItem(at: IndexPath(row: destinationRow, section: 0))
        cell?.layer.shadowOpacity = 0.0
        cell?.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell?.isHidden = false
    }
    
    func setupUnderTopView(){
        underTopView.layer.shadowColor = UIColor.black.cgColor
        underTopView.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(4.0))
        underTopView.layer.shadowOpacity = 0.0
        underTopView.layer.shadowRadius = 10
    }
    
    func updateLabelFrame(label: UILabel){
        label.numberOfLines = 3
        let maxSize = CGSize(width: 256, height: 100)
        let size = label.sizeThatFits(maxSize)
        label.frame = CGRect(origin: CGPoint(x: label.frame.origin.x, y: label.frame.origin.y), size: size)
    }
    
    func checkLabelFrame(label: UILabel) -> CGFloat{
        label.numberOfLines = 3
        let maxSize = CGSize(width: 256, height: 100)
        let size = label.sizeThatFits(maxSize)
        return size.height
    }
    
    func openGroupsView(){
        
        let groupsView = createGroupsView()
        
        groupsView.tV.reloadData()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            groupsView.frame.origin = CGPoint(x: 0, y: 0)
            self.blackButton.isHidden = false
        }, completion: { finished in
        })

        groupsView.label.text = cvTasks[beginRow].name
        updateLabelFrame(label: groupsView.label)
        
        groupsView.replace_label.frame.origin = CGPoint(x: groupsView.replace_label.frame.origin.x, y: groupsView.label.frame.origin.y + groupsView.label.frame.size.height + 6.0)
        groupsView.tV.frame.origin = CGPoint(x: groupsView.tV.frame.origin.x, y: groupsView.replace_label.frame.origin.y + groupsView.replace_label.frame.size.height + 20.0)
        if ((groupsView.tV.contentSize.height + groupsView.tV.frame.origin.y) > self.view.frame.size.height){
            groupsView.tV.frame.size = CGSize(width: groupsView.tV.frame.size.width, height: self.view.frame.size.height - groupsView.tV.frame.origin.y)
            groupsView.tV.isScrollEnabled = true
        }
        else{
            groupsView.tV.frame.size = CGSize(width: groupsView.tV.frame.size.width, height: groupsView.tV.contentSize.height)
            groupsView.tV.isScrollEnabled = false
        }
        groupsView.frame.size.height = groupsView.tV.frame.origin.y + groupsView.tV.frame.size.height
        
        isViewOpen = 4
        changeButton(toRed: true)
    }
    
    func closeGroupsView(){
        isViewOpen = 0
        
        let groupsView = generalView as! GroupsView
    
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            groupsView.frame.origin = CGPoint(x: 0, y: -self.view.frame.size.height)
            self.blackButton.isHidden = true
        }, completion: { finished in
        })
        changeButton(toRed: false)
    }
    
    func changeButton(toRed: Bool){
        
        if (toRed){
            addButton.backgroundColor = UIColor(red: 252/255.0, green: 73/255.0, blue: 95/255.0, alpha: 1.0)
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.rightButton_image.transform = self.rightButton_image.transform.rotated(by: CGFloat(CGFloat.pi/4))
            }, completion: { finished in
            })
        }
        else{
            addButton.backgroundColor = UIColor(red: 67/255.0, green: 191/255.0, blue: 128/255.0, alpha: 1.0)
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.rightButton_image.transform = self.rightButton_image.transform.rotated(by: CGFloat(CGFloat.pi/4))
            }, completion: { finished in
            })
        }
        
    }
    
    func openCalendarView(){
        
        isViewOpen = 1
        let calendarView = createCalendarView()
        
        calendarView.cV.reloadData()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            calendarView.frame.origin = CGPoint(x: 0, y: 0)
            self.blackButton.isHidden = false
        }, completion: { finished in
        })
        changeButton(toRed: true)
        
    }
    
    func closeCalendarView(){
        isViewOpen = 0
        let calendarView = generalView as! CalendarView
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            calendarView.frame.origin = CGPoint(x: 20, y: -self.view.frame.size.height)
            self.blackButton.isHidden = true
        }, completion: { finished in
        })
        changeButton(toRed: false)
    }
    
    func openNotificationView(){
        isViewOpen = 2
        self.addNotificationView.frame.origin = CGPoint(x: 20, y: -140)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.addNotificationView.frame.origin = CGPoint(x: 20, y: 140)
            self.secondBlackButton.isHidden = false
        }, completion: { finished in
        })
        changeButton(toRed: true)
    }
    
    func closeNotificationView(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.addNotificationView.frame.origin = CGPoint(x: 20, y: -140)
            self.secondBlackButton.isHidden = true
        }, completion: { finished in
        })
        changeButton(toRed: true)
    }
    
    func createGroupsView() -> GroupsView{
        generalView = GroupsView(frame: CGRect(x: 0, y: -self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - bottomMargin))
        let groupsView = generalView as! GroupsView
        groupsView.layer.shadowColor = UIColor.black.cgColor
        groupsView.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(4.0))
        groupsView.layer.shadowOpacity = 0.06
        groupsView.layer.shadowRadius = 10
        groupsView.tV.dataSource = self
        groupsView.tV.delegate = self
        setupGroupsCell()
        return groupsView
    }
    
    func createCalendarView() -> CalendarView{
        generalView = CalendarView(frame: CGRect(x: 0, y: -self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - bottomMargin))
        let calendarView = generalView as! CalendarView
        calendarView.cV.minimumLineSpacing = 0
        calendarView.cV.minimumInteritemSpacing = 0
        calendarView.frame.origin = CGPoint(x: 0, y: -(calendarView.frame.size.height) - 50.0)
        calendarView.layer.shadowColor = UIColor.black.cgColor
        calendarView.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(4.0))
        calendarView.layer.shadowOpacity = 0.06
        calendarView.layer.shadowRadius = 10
        calendarView.cV.calendarDataSource = self
        calendarView.cV.calendarDelegate = self
        setupCalendarCell()
        return calendarView
    }
    
    func setupAddNotificationView(){
        addNotificationView.frame.origin = CGPoint(x: 20, y: -(addNotificationView.frame.size.height) - 50.0)
        addNotificationView.layer.cornerRadius = 5
    }
    
    func setupCalendarCell(){
        let calendarCellNib = UINib(nibName: "CalendarCell", bundle: nil)
        let calendarView = generalView as! CalendarView
        calendarView.cV.register(calendarCellNib, forCellWithReuseIdentifier: "calendarCell")
        calendarView.addNotificationButton.addTarget(self, action: #selector(openNotificationView), for: .touchUpInside)
    }
    
    func setupGroupsCell(){
        let groupsView = generalView as! GroupsView
        let groupsCellNib = UINib(nibName: "GroupsCell", bundle: nil)
        groupsView.tV.register(groupsCellNib, forCellReuseIdentifier: "groupsCell")
    }
    
    func createCustomView(){
        
        customView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        customView.backgroundColor = UIColor.white
        customView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        customView.layer.shadowOpacity = 0.05
        customView.layer.shadowOffset = CGSize(width: 0, height: -1)
        customView.layer.shadowRadius = 5
        
        let scrollView = UIScrollView(frame: CGRect(x: 20, y: 0, width:236, height: 44))
        customView.addSubview(scrollView)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 6, width:20, height: 32))
        leftView.backgroundColor = .white
        leftView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        leftView.layer.shadowOpacity = 0.15
        leftView.layer.shadowRadius = 5
        leftView.layer.shadowOffset = CGSize(width: 1, height: 0)
        customView.addSubview(leftView)
        
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width:20, height: 44))
        leftButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        leftButton.backgroundColor = .white
        customView.addSubview(leftButton)
        
        more_leftView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        more_leftView.layer.shadowOpacity = 0.15
        more_leftView.layer.shadowRadius = 5
        more_leftView.layer.shadowOffset = CGSize(width: 1, height: 0)
        
        let rightView = UIView(frame: CGRect(x: 256, y: 6, width:20, height: 32))
        rightView.backgroundColor = .white
        rightView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        rightView.layer.shadowOpacity = 0.15
        rightView.layer.shadowRadius = 5
        rightView.layer.shadowOffset = CGSize(width: -1, height: 0)
        customView.addSubview(rightView)
        
        let rightButton = UIButton(frame: CGRect(x: 256, y: 0, width:20, height: 44))
        rightButton.setImage(UIImage(named: "rightArrow-1"), for: .normal)
        rightButton.backgroundColor = .white
        customView.addSubview(rightButton)
        
        more_rightView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        more_rightView.layer.shadowOpacity = 0.15
        more_rightView.layer.shadowRadius = 5
        more_rightView.layer.shadowOffset = CGSize(width: -1, height: 0)
        
        let more_calendarButton = UIButton(frame: CGRect(x: 5, y: 6, width: 135, height: 32))
        more_calendarButton.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_calendarButton.setImage(UIImage(named: "calendar_gray"), for: .normal)
        more_calendarButton.setTitle("Пн. 12 октября", for: .normal)
        more_calendarButton.imageEdgeInsets = UIEdgeInsetsMake(-2.0, 0.0, 0.0, 10.0)
        more_calendarButton.titleLabel?.font = UIFont(name: "MuseoSansCyrl-300", size: 14)
        more_calendarButton.setTitleColor(UIColor(red: 177/255.0, green: 177/255.0, blue: 177/255.0, alpha: 1.0), for: .normal)
        more_calendarButton.layer.shadowOpacity = 0.0
        scrollView.addSubview(more_calendarButton)
        let copy_calendarButton = more_calendarButton.copyView()
        more_iconsScrollView.addSubview(copy_calendarButton)
        
        let more_notificationButton = UIButton(frame: CGRect(x: 145, y: 6, width: 32, height: 32))
        more_notificationButton.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_notificationButton.setImage(UIImage(named: "notification_grey"), for: .normal)
        scrollView.addSubview(more_notificationButton)
        let copy_notificationButton = more_notificationButton.copyView()
        more_iconsScrollView.addSubview(copy_notificationButton)
        
        let more_tagButton = UIButton(frame: CGRect(x: 182, y: 6, width: 32, height: 32))
        more_tagButton.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_tagButton.setImage(UIImage(named: "tag_gray"), for: .normal)
        more_tagButton.addTarget(self, action: #selector(addTags), for: .touchUpInside)
        scrollView.addSubview(more_tagButton)
        let copy_tagButton = more_tagButton.copyView()
        copy_tagButton.addTarget(self, action: #selector(addTags), for: .touchUpInside)
        more_iconsScrollView.addSubview(copy_tagButton)
        
        let more_listButton = UIButton(frame: CGRect(x: 219, y: 6, width: 32, height: 32))
        more_listButton.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_listButton.setImage(UIImage(named: "list_gray"), for: .normal)
        more_listButton.addTarget(self, action: #selector(addCheckList), for: .touchUpInside)
        scrollView.addSubview(more_listButton)
        let copy_listButton = more_listButton.copyView()
        copy_listButton.addTarget(self, action: #selector(addCheckList), for: .touchUpInside)
        more_iconsScrollView.addSubview(copy_listButton)
        
        let more_messageButton = UIButton(frame: CGRect(x: 256, y: 6, width: 32, height: 32))
        more_messageButton.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_messageButton.setImage(UIImage(named: "message_gray"), for: .normal)
        scrollView.addSubview(more_messageButton)
        let copy_messageButton = more_messageButton.copyView()
        more_iconsScrollView.addSubview(copy_messageButton)
        
        let more_cursorButton = UIButton(frame: CGRect(x: 293, y: 6, width: 32, height: 32))
        more_cursorButton.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_cursorButton.setImage(UIImage(named: "cursor"), for: .normal)
        scrollView.addSubview(more_cursorButton)
        let copy_cursorButton = more_cursorButton.copyView()
        more_iconsScrollView.addSubview(copy_cursorButton)
        
        let more_shareButton = UIButton(frame: CGRect(x: 330, y: 6, width: 32, height: 32))
        more_shareButton.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_shareButton.setImage(UIImage(named: "share"), for: .normal)
        scrollView.addSubview(more_shareButton)
        let copy_shareButton = more_shareButton.copyView()
        more_iconsScrollView.addSubview(copy_shareButton)
        
        let more_hourGlassButton = UIButton(frame: CGRect(x: 367, y: 6, width: 32, height: 32))
        more_hourGlassButton.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_hourGlassButton.setImage(UIImage(named: "hourglass"), for: .normal)
        scrollView.addSubview(more_hourGlassButton)
        let copy_hourGlassButton = more_hourGlassButton.copyView()
        more_iconsScrollView.addSubview(copy_hourGlassButton)
        
        let more_delegateButton = UIButton(frame: CGRect(x: 404, y: 6, width: 32, height: 32))
        more_delegateButton.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_delegateButton.setImage(UIImage(named: "delegate"), for: .normal)
        scrollView.addSubview(more_delegateButton)
        let copy_delegateButton = more_delegateButton.copyView()
        more_iconsScrollView.addSubview(copy_delegateButton)
        
        let more_flameButton = UIButton(frame: CGRect(x: 441, y: 6, width: 32, height: 32))
        more_flameButton.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_flameButton.setImage(UIImage(named: "flame-icon"), for: .normal)
        scrollView.addSubview(more_flameButton)
        let copy_flameButton = more_flameButton.copyView()
        more_iconsScrollView.addSubview(copy_flameButton)
        
        let more_flameButton_green = UIButton(frame: CGRect(x: 478, y: 6, width: 32, height: 32))
        more_flameButton_green.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_flameButton_green.setImage(UIImage(named: "flame-icon-green"), for: .normal)
        scrollView.addSubview(more_flameButton_green)
        let copy_flameButton_green = more_flameButton_green.copyView()
        more_iconsScrollView.addSubview(copy_flameButton_green)
        
        let more_flameButton_yellow = UIButton(frame: CGRect(x: 515, y: 6, width: 32, height: 32))
        more_flameButton_yellow.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_flameButton_yellow.setImage(UIImage(named: "flame-icon-yellow"), for: .normal)
        scrollView.addSubview(more_flameButton_yellow)
        let copy_flameButton_yellow = more_flameButton_yellow.copyView()
        more_iconsScrollView.addSubview(copy_flameButton_yellow)
        
        let more_flameButton_red = UIButton(frame: CGRect(x: 552, y: 6, width: 32, height: 32))
        more_flameButton_red.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_flameButton_red.setImage(UIImage(named: "flame-icon-red"), for: .normal)
        scrollView.addSubview(more_flameButton_red)
        let copy_flameButton_red = more_flameButton_red.copyView()
        more_iconsScrollView.addSubview(copy_flameButton_red)
        
        let dismissKeyboardView = UIView(frame: CGRect(x: 276, y: 0, width: 44, height: 44))
        dismissKeyboardView.backgroundColor = .white
        customView.addSubview(dismissKeyboardView)
        
        let more_dismissKeyboardButton = UIButton(frame: CGRect(x: 283, y: 6, width: 32, height: 32))
        more_dismissKeyboardButton.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_dismissKeyboardButton.setImage(UIImage(named: "hide-keyboard-button"), for: .normal)
        more_dismissKeyboardButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        customView.addSubview(more_dismissKeyboardButton)
        
        scrollView.contentSize.width = 135.0 + 12*32.0 + 13*5.0
        scrollView.showsHorizontalScrollIndicator = false
        more_iconsScrollView.contentSize.width = 135.0 + 12*32.0 + 13*5.0
        more_iconsScrollView.showsHorizontalScrollIndicator = false
    }
    
    
    

}
