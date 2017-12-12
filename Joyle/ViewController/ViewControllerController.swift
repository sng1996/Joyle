//
//  ViewControllerController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 18.11.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

extension ViewController{

    func getIndexPaths() -> [IndexPath]{
        var indexPaths: [IndexPath] = []
        for s in 0..<cV.numberOfSections {
            for i in 0..<cV.numberOfItems(inSection: s) {
                indexPaths.append(IndexPath(row: i, section: s))
            }
        }
        return indexPaths
    }
    
    func pass(data: Task, path: IndexPath) {
        cvTasks[path.row] = data
    }
    
    func closeTask(indexPath: IndexPath) {
        
        for element in 0..<cvTasks[indexPath.row].subtasks.count{
            if (cvTasks[indexPath.row+1].isOpen){
                closeTask(indexPath: IndexPath(item: indexPath.row+1, section: 0))
            }
            cvTasks.remove(at: indexPath.row+1)
            let tmp = IndexPath(item: indexPath.row+1, section: 0)
            cV.deleteItems(at: [tmp])
        }
        
        cvTasks[indexPath.row].isOpen = false
        let cell = cV.cellForItem(at: indexPath) as! TaskCell
        changeArrow(cell: cell, isOpen: cvTasks[indexPath.row].isOpen, isParent: !cvTasks[indexPath.row].subtasks.isEmpty)
        
    }
    
    func openTask(indexPath: IndexPath){
        cvTasks[indexPath.row].isOpen = true
        let cell = cV.cellForItem(at: indexPath) as! TaskCell
        for element in 0..<cvTasks[indexPath.row].subtasks.count{
            cvTasks[indexPath.row].subtasks[element].level = cvTasks[indexPath.row].level + 1
            cvTasks.insert(cvTasks[indexPath.row].subtasks[element], at: indexPath.row + element + 1)
            cV.insertItems(at: [IndexPath(item: indexPath.row + element + 1, section: 0)])
        }
        changeArrow(cell: cell, isOpen: cvTasks[indexPath.row].isOpen, isParent: !cvTasks[indexPath.row].subtasks.isEmpty)
    }
    
    func updating(gesture: UILongPressGestureRecognizer){
        
        guard let currentIndexPath = cV.indexPathForItem(at: gesture.location(in: cV)) else {
            return
        }
        
        let locY = Int((gesture.location(in: cV).y - 5) / 40) * 40 + 5
        let cellFrameInSuperview:CGRect! = cV.convert(CGRect(x: 10, y: locY, width: 300, height: 40), to: cV.superview)
        rectView.isHidden = false
        rectView.frame = cellFrameInSuperview
        
        var pastLevel: Int = 0
        var previousLevel: Int = 0
        
        if (beginRow < currentIndexPath.row){
            previousLevel = cvTasks[currentIndexPath.row].level
            setMarkToParent(at: currentIndexPath.row+1)
        }
        else{
            setMarkToParent(at: currentIndexPath.row)
            if (currentIndexPath.row > 0){
                previousLevel = cvTasks[currentIndexPath.row-1].level
            }
            else{
                previousLevel = -1
            }
        }
        
        if (beginRow > currentIndexPath.row){
            pastLevel = cvTasks[currentIndexPath.row].level
        }
        else{
            if (currentIndexPath.row + 1 < cvTasks.count){
                pastLevel = cvTasks[currentIndexPath.row+1].level
            }
            else{
                pastLevel = 0
            }
            
        }
        
        if (previousLevel > 3){
            previousLevel = 3
        }
        
        drawLine(past: pastLevel, previous: previousLevel, gesture: gesture)
        
    }
    
    func drawLine(past: Int, previous: Int, gesture: UILongPressGestureRecognizer){
        if (gesture.location(in: cV).x > self.view.frame.width/2){
            mainLevel = Int((gesture.location(in: cV).x - self.view.frame.width/2)/10)
        }
        else{
            mainLevel = 0
        }
        
        if (mainLevel < past){
            mainLevel = past
        }
        if (mainLevel > previous + 1){
            mainLevel = previous + 1
        }
        
        setLevel(level: mainLevel)
        
    }
    
    func insertInParent(element: Task, at: Int){
        
        element.level = mainLevel
        if (element.level > 0){
            for i in 0..<at{
                if (cvTasks[at-i-1].level == mainLevel){
                    let indexOfA = cvTasks[at-i-1].parent.subtasks.index(of: cvTasks[at-i-1])
                    cvTasks[at-i-1].parent.subtasks.insert(element, at: indexOfA!+1)
                    cvTasks[at-i-1].parent.isOpen = true
                    element.parent = cvTasks[at-i-1].parent
                    break
                } else if (cvTasks[at-i-1].level < mainLevel){
                    cvTasks[at-i-1].subtasks.insert(element, at: 0)
                    cvTasks[at-i-1].isOpen = true
                    element.parent = cvTasks[at-i-1]
                    break
                }
            }
        } else{
            element.parent = nil
            element.level = 0
        }
        
        mainLevel = 0
        
    }
    
    func closeEmptyTask(from: Int){
        
        let currentTask = cvTasks[from]
        
        if (currentTask.level > 0 && currentTask.parent.subtasks.count == 1 && currentTask.parent.isOpen){
            currentTask.parent.isOpen = false
        }
        
    }
    
    func removeFromParent(from: Int){
        
        let currentTask = cvTasks[from]
        if (currentTask.level > 0){
            let indexOfA = currentTask.parent.subtasks.index(of: currentTask)
            currentTask.parent.subtasks.remove(at: indexOfA!)
        }
        
    }
    
    func setLevel(level: Int){
        
        for i in 0..<5{
            views[i].isHidden = true
        }
        
        for i in 0..<level+1{
            views[i].isHidden = false
        }
        
    }
    
    func setMarkToParent(at: Int){
        clearMarkOfParent()
        if (mainLevel > 0){
            for i in 0..<at{
                if (cvTasks[at-i-1].level == mainLevel){
                    let indexOfA = cvTasks.index(of: cvTasks[at-i-1].parent)
                    setupCheckBox(indexOfA: indexOfA!)
                    break
                } else if (cvTasks[at-i-1].level < mainLevel){
                    let indexOfA = cvTasks.index(of: cvTasks[at-i-1])
                    setupCheckBox(indexOfA: indexOfA!)
                    break
                }
            }
        }
    }
    
    func setupCheckBox(indexOfA: Int){
        let cell = cV.cellForItem(at: IndexPath(row: indexOfA, section: 0)) as? TaskCell
        cell?.checkButton.backgroundColor = UIColor(red: 131/255.0, green: 231/255.0, blue: 180/255.0, alpha: 1.0)
        cell?.checkButton.layer.borderWidth = 0
        cell?.plusImageView.isHidden = false
    }
    
    func clearMarkOfParent(){
        for i in 0..<cV.visibleCells.count{
            let cell = cV.visibleCells[i] as? TaskCell
            cell?.checkButton.backgroundColor = .white
            cell?.checkButton.layer.borderWidth = 1
            cell?.plusImageView.isHidden = true
        }
    }
    
    func beganDrag(gesture: UILongPressGestureRecognizer){
        guard let selectedIndexPath = cV.indexPathForItem(at: gesture.location(in: cV)) else {
            return
        }
        setupCurrentCell(selectedIndexPath: selectedIndexPath)
        beginRow = selectedIndexPath.row
        replaceView.isHidden = false
        if (cvTasks[selectedIndexPath.row].isOpen){
            closeTask(indexPath: selectedIndexPath)
        }
        dragView.isHidden = false
        dragView.layer.zPosition = 1
        dragView.center = cV.convert(gesture.location(in: cV), to: self.view)
        let label = dragView.subviews[1] as? UILabel
        label?.text = cvTasks[selectedIndexPath.row].name
        
        cV.beginInteractiveMovementForItem(at: selectedIndexPath)
        cV.updateInteractiveMovementTargetPosition(gesture.location(in: cV))
        
        updating(gesture: gesture)
    }
    
    func changedDrag(gesture: UILongPressGestureRecognizer){
        cV.updateInteractiveMovementTargetPosition(gesture.location(in: cV))
        
        dragView.center = cV.convert(gesture.location(in: cV), to: self.view)
        if (cV.convert(gesture.location(in: cV), to: self.view).y < 104){
            underTopView.backgroundColor = UIColor(red: 67/255.0, green: 191/255.0, blue: 128/255.0, alpha: 1.0)
            replaceView.backgroundColor = UIColor(red: 67/255.0, green: 191/255.0, blue: 128/255.0, alpha: 1.0)
            borderSublayer.strokeColor = UIColor.white.cgColor
            let label = replaceView.subviews[0] as? UILabel
            label?.textColor = .white
        }
        else{
            underTopView.backgroundColor = .white
            replaceView.backgroundColor = .white
            borderSublayer.strokeColor = UIColor(red: 202/255.0, green: 202/255.0, blue: 202/255.0, alpha: 1.0).cgColor
            let label = replaceView.subviews[0] as? UILabel
            label?.textColor = UIColor(red: 202/255.0, green: 202/255.0, blue: 202/255.0, alpha: 1.0)
            
        }
        
        updating(gesture: gesture)
        
        guard let destinationIndexPath = cV.indexPathForItem(at: gesture.location(in: cV)) else {
            return
        }
        
        destinationRow = destinationIndexPath.row
    }
    
    func endedDrag(gesture: UILongPressGestureRecognizer){
        if (cV.convert(gesture.location(in: cV), to: self.view).y < 104){
            openGroupsView()
        }
        cV.endInteractiveMovement()
        clearMarkOfParent()
        setupDroppedCell()
        rectView.isHidden = true
        replaceView.isHidden = true
        dragView.isHidden = true
        underTopView.backgroundColor = .white
        
        if (beginRow == destinationRow){
            if (cvTasks[beginRow].level > 0 && mainLevel >= cvTasks[beginRow].parent.level){
                closeEmptyTask(from: beginRow)
                removeFromParent(from: beginRow)
            }
            cvTasks[beginRow].level = mainLevel
            insertInParent(element: cvTasks[beginRow], at: beginRow)
        }
        
        cV.reloadData()
    }
    
    func updateData_tasks(){
        
        list_task_items()
        cvTasks.removeAll()
        for _task in groups[groupIndex].tasks{
            cvTasks.append(_task)
        }
        cV.reloadData()
        
    }
    
}
