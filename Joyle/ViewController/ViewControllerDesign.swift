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
        groupsView.tV.reloadData()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.groupsView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { finished in
        })
        blackView.isHidden = false
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
        changeButton(toRed: true)
    }
    
    func closeGroupsView(){
        isViewOpen = 4
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.groupsView.frame.origin = CGPoint(x: 0, y: -(self.groupsView.frame.size.height) - 50.0)
        }, completion: { finished in
        })
        blackView.isHidden = true
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
        calendarView.cV.reloadData()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.calendarView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { finished in
        })
        blackView.isHidden = false
        changeButton(toRed: true)
        
    }
    
    func closeCalendarView(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.calendarView.frame.origin = CGPoint(x: 20, y: -(self.calendarView.frame.size.height) - 50.0)
        }, completion: { finished in
        })
        secondBlackView.isHidden = true
        changeButton(toRed: false)
    }
    
    func openNotificationView(){
        isViewOpen = 2
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.addNotificationView.frame.origin = CGPoint(x: 20, y: 140)
        }, completion: { finished in
        })
        secondBlackView.isHidden = false
        changeButton(toRed: true)
        
    }
    
    func closeNotificationView(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.addNotificationView.frame.origin = CGPoint(x: 20, y: -(self.calendarView.frame.size.height) - 50.0)
        }, completion: { finished in
        })
        secondBlackView.isHidden = true
        changeButton(toRed: false)
    }
    
    func setupGroupsView(){
        groupsView.frame.origin = CGPoint(x: 0, y: -(groupsView.frame.size.height) - 50.0)
        groupsView.layer.shadowColor = UIColor.black.cgColor
        groupsView.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(4.0))
        groupsView.layer.shadowOpacity = 0.06
        groupsView.layer.shadowRadius = 10
        groupsView.tV.dataSource = self
        groupsView.tV.delegate = self
    }
    
    func setupCalendarView(){
        calendarView.cV.minimumLineSpacing = 0
        calendarView.cV.minimumInteritemSpacing = 0
        calendarView.frame.origin = CGPoint(x: 0, y: -(calendarView.frame.size.height) - 50.0)
        calendarView.layer.shadowColor = UIColor.black.cgColor
        calendarView.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(4.0))
        calendarView.layer.shadowOpacity = 0.06
        calendarView.layer.shadowRadius = 10
        calendarView.cV.calendarDataSource = self
        calendarView.cV.calendarDelegate = self
    }
    
    func setupAddNotificationView(){
        addNotificationView.frame.origin = CGPoint(x: 20, y: -(addNotificationView.frame.size.height) - 50.0)
        addNotificationView.layer.cornerRadius = 5
    }
    
    func setupCalendarCell(){
        let calendarCellNib = UINib(nibName: "CalendarCell", bundle: nil)
        calendarView.cV.register(calendarCellNib, forCellWithReuseIdentifier: "calendarCell")
        calendarView.addNotificationButton.addTarget(self, action: #selector(openNotificationView), for: .touchUpInside)
    }
    
    func setupGroupsCell(){
        let groupsCellNib = UINib(nibName: "GroupCell", bundle: nil)
        groupsView.tV.register(groupsCellNib, forCellReuseIdentifier: "groupCell")
    }
    
    
    

}
