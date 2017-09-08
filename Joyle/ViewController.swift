//
//  ViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 06.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    @IBOutlet var cV: UICollectionView!
    @IBOutlet var ok: UIBarButtonItem!
    var sections: [Section] = []
    var tmpSection: Section!
    var currentElementIndex: Int = 0
    var tmpTask: Task!
    var isCopyTime: Bool = false
    var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let section = Section()
        sections.append(section)
        
        for i in 0...10{
            let task = Task(name: "Task " + String(i))
            sections[0].tasks.append(task)
        }
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        cV.addGestureRecognizer(longPressGesture)
        
        ok.title = ""
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            
            guard let selectedIndexPath = cV.indexPathForItem(at: gesture.location(in: cV)) else {
                break
            }
            cV.beginInteractiveMovementForItem(at: selectedIndexPath)
            
        case UIGestureRecognizerState.changed:
            
            cV.updateInteractiveMovementTargetPosition(gesture.location(in: cV))
            
        case UIGestureRecognizerState.ended:
            
            cV.endInteractiveMovement()
            cV.reloadData()
            
        default:
            cV.cancelInteractiveMovement()
        }
        
    }
    
    func getIndexPaths() -> [IndexPath]{
        
        var indexPaths: [IndexPath] = []
        for s in 0..<cV.numberOfSections {
            for i in 0..<cV.numberOfItems(inSection: s) {
                indexPaths.append(IndexPath(row: i, section: s))
            }
        }
        return indexPaths
        
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: collectionView.bounds.width, height: 50)
        return itemSize
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].tasks.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addTaskCell", for: indexPath) as! AddTaskCell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TaskCell
        
        if (indexPath.section == 0 && indexPath.row == 0){
            return addCell
        }
        
        cell.label.text = sections[indexPath.section].tasks[indexPath.row].name
        
        cell.labelStatus.text = ""
        
        switch(sections[indexPath.section].level){
            
            case 0:
                cell.labelStatus.textColor = UIColor.black
                break
            case 1:
                cell.labelStatus.textColor = UIColor.red
                break
            case 2:
                cell.labelStatus.textColor = UIColor.blue
                break
            default: break
            
        }
        
        if (sections[indexPath.section].level > 0){
            cell.labelStatus.text = "•"
        }
        
        if (sections[indexPath.section].tasks[indexPath.row].subtasks.count > 0){
            if(sections[indexPath.section].tasks[indexPath.row].isOpen){
                cell.labelStatus.text = "v"
            }
            else{
                cell.labelStatus.text = ">"
            }
        }
        
        
        cell.setNeedsLayout()
        
        return cell
        
    }
    

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let temp = sections[sourceIndexPath.section].tasks.remove(at: sourceIndexPath.item)
        sections[destinationIndexPath.section].tasks.insert(temp, at: destinationIndexPath.item)
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (isCopyTime){
            sections[indexPath.section].tasks[indexPath.row].subtasks.append(tmpTask)
            cV.reloadData()
            isCopyTime = false
        }
        else{
            if (sections[indexPath.section].tasks[indexPath.row].subtasks.count != 0 && sections[indexPath.section].tasks[indexPath.row].isOpen == false){
                
                sections[indexPath.section].tasks[indexPath.row].isOpen = true
                tmpSection = sections.remove(at: indexPath.section)
                sections.insert(Section(tasks: Array<Task>(tmpSection.tasks[0..<indexPath.row+1]), level:tmpSection.level), at: indexPath.section)
                sections.insert(Section(tasks: tmpSection.tasks[indexPath.row].subtasks, level:tmpSection.level+1), at: indexPath.section+1)
                
                if(indexPath.row + 1 < tmpSection.tasks.count){
                    
                    sections.insert(Section(tasks: Array<Task>(tmpSection.tasks[indexPath.row+1..<tmpSection.tasks.count]), level:tmpSection.level), at:indexPath.section+2)
                    
                }
                
            }
                
            else if (sections[indexPath.section].tasks[indexPath.row].isOpen == true){
                
                closeTask(indexPath: indexPath)
                
            }
        }
        
        cV.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        tmpTask = sections[indexPath.section].tasks[indexPath.row]
        sections[indexPath.section].tasks.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        isCopyTime = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var edgeInsets = UIEdgeInsets()
        edgeInsets = UIEdgeInsetsMake(5,5,5,5)
        return edgeInsets;
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        ok.title = "Готово"

    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        ok.title = ""
        return true
    }
    
    func closeTask(indexPath: IndexPath) { //должна быть открыта и иметь подзадачи
        
        var c: Int = 0
        
        
        for sectionNum in indexPath.section+1..<sections.count{
            if (sections[sectionNum].level == sections[indexPath.section+1].level){
                c += cV.numberOfItems(inSection: sectionNum)
            }
            if (sections[sectionNum].level > sections[indexPath.section+1].level){
                break
            }
        }
        
        for i in 0..<c{                         //Закрываем все подзадачи рекурсивно
            if sections[indexPath.section + 1].tasks[i].isOpen{
                closeTask(indexPath: IndexPath(row: i, section: indexPath.section + 1))
            }
        }
        
        sections[indexPath.section].tasks[indexPath.row].isOpen = false
        let currentLevel = sections[indexPath.section].level
        var count: Int = 0
        
        if (indexPath.section+2 < sections.count && sections[indexPath.section+2].level == currentLevel){
            tasks = sections[indexPath.section].tasks + sections[indexPath.section+2].tasks
            count = 3
        }
        else{
            tasks = sections[indexPath.section].tasks
            count = 2
        }
        
        for j in 0..<count{
            sections.remove(at: indexPath.section)
        }
        
        
        sections.insert(Section(tasks: tasks, level: currentLevel), at: indexPath.section)
        cV.reloadData()
        
    }

    
    @IBAction func pressOkButton(){
        
        addTask()
        
    }
    
    /*func reset(sender: UISwipeGestureRecognizer) {
        let cell = sender.view as! UICollectionViewCell
        let i = self.cV.indexPath(for: cell)!.item
        tasks.remove(at: i)  //replace favoritesInstance.favoritesArray with your own array
        self.cV.reloadData() // replace favoritesCV with your own collection view.
    }*/
    
    func dismissKeyboard() {

        addTask()
        
    }
    
    func addTask(){
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = cV.cellForItem(at: indexPath) as! AddTaskCell
        cell.textField.resignFirstResponder()                   //    dismiss keyboard
        
        if (cell.textField.text != ""){
            let task = Task(name: cell.textField.text!)
            sections[0].tasks.insert(task, at: 1)
            cell.textField.text = ""
            cV.reloadData()
        }
        
    }
    
    
}




