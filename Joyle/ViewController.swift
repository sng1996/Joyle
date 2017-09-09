//
//  ViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 06.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

// сделать insert в коллекцию, должно быть с анимацией
// свайп не по скорости а по длине


import UIKit

class ViewController: UIViewController {
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    @IBOutlet var cV: UICollectionView!
    @IBOutlet var ok: UIBarButtonItem!
    @IBOutlet var datePicker: UIDatePicker!
    var sections: [Section] = []
    var tmpSection: Section!
    var currentElementIndex: Int = 0
    var tmpTask: Task!
    var isCopyTime: Bool = false
    var isSetDate: Bool = false
    var tmpTasks: [Task] = []
    var finishedTasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let section = Section()
        sections.append(section)
        let tmpT: [Task] = []
        sections[0].tasks = tmpT
        
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
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        datePicker.backgroundColor = UIColor.white
        
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
            
            let customView = UIView(frame: CGRect(x:0,y:0,width:320,height:40))
            var btn = UIButton(frame: CGRect(x:205,y:5,width:100,height:30))
            btn.setTitle("Calendar", for: .normal)
            btn.setTitleColor(UIColor.blue, for: .normal)
            btn.addTarget(self, action: #selector(openCalendar), for: UIControlEvents.touchUpInside)
            customView.backgroundColor = UIColor.white
            customView.addSubview(btn)
            addCell.textField.inputAccessoryView = customView
            
            return addCell
            
        }
        
        cell.label.text = sections[indexPath.section].tasks[indexPath.row].name
        cell.labelDate.text = sections[indexPath.section].tasks[indexPath.row].date
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
        
        if (sections[sourceIndexPath.section].level > 0){
            sections[sourceIndexPath.section].tasks[sourceIndexPath.row].parent.subtasks.remove(at: sourceIndexPath.row)
        }
        let temp = sections[sourceIndexPath.section].tasks.remove(at: sourceIndexPath.item)
    
        
        if (sections[destinationIndexPath.section].level > 0){
            
            sections[destinationIndexPath.section].tasks[0].parent.subtasks.insert(temp, at: destinationIndexPath.row)

        }

        sections[destinationIndexPath.section].tasks.insert(temp, at: destinationIndexPath.row)
        

        if (sections[sourceIndexPath.section].level > 0){
        
            let section: Int = sourceIndexPath.section-1
            let row: Int = sections[sourceIndexPath.section-1].tasks.count-1
        
            if (sections[sourceIndexPath.section].tasks.count == 0 && sections[sourceIndexPath.section].level > 0){
                closeTask(indexPath: IndexPath(item: row, section: section))
            }
            
        }
        
    
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (isCopyTime){
            tmpTask.parent = sections[indexPath.section].tasks[indexPath.row]
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
    
    internal func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        let flag = sender as! Int
        var tmpParent: Task!
        if (sections[indexPath.section].level > 0){
            tmpParent = sections[indexPath.section].tasks[indexPath.row].parent
        }
        
        if (flag == 1){    //копирование задачи
            if (sections[indexPath.section].level > 0){
                tmpParent.subtasks.remove(at: indexPath.row)
            }
            tmpTask = sections[indexPath.section].tasks.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
            if (sections[indexPath.section].level > 0 && tmpParent.subtasks.count == 0){
                let section: Int = indexPath.section-1
                let row: Int = sections[indexPath.section-1].tasks.count-1
                closeTask(indexPath: IndexPath(item: row, section: section))
            }
            isCopyTime = true
        } else if (flag == 2){          //закрытие задачи
            sections[indexPath.section].tasks[indexPath.row].isFinish = true //ПРОВЕРИТЬ ЭТОТ МОМЕНТ
            finishedTasks.append(sections[indexPath.section].tasks.remove(at: indexPath.row))
            if (sections[indexPath.section].level > 0){
                tmpParent.subtasks.remove(at: indexPath.row)
            }
            collectionView.deleteItems(at: [indexPath])
            if (sections[indexPath.section].level > 0 && tmpParent.subtasks.count == 0){
                let section: Int = indexPath.section-1
                let row: Int = sections[indexPath.section-1].tasks.count-1
                closeTask(indexPath: IndexPath(item: row, section: section))
            }
        } else if (flag == 3){          //удаление задачи
            sections[indexPath.section].tasks.remove(at: indexPath.row)
            if (sections[indexPath.section].level > 0){
                tmpParent.subtasks.remove(at: indexPath.row)
            }
            collectionView.deleteItems(at: [indexPath])
            if (sections[indexPath.section].level > 0 && tmpParent.subtasks.count == 0){
                let section: Int = indexPath.section-1
                let row: Int = sections[indexPath.section-1].tasks.count-1
                closeTask(indexPath: IndexPath(item: row, section: section))
            }
        }
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
        print(indexPath.row)
        print(indexPath.section)
        let currentLevel = sections[indexPath.section].level
        var count: Int = 0
        
        if (indexPath.section+2 < sections.count && sections[indexPath.section+2].level == currentLevel){
            tmpTasks = sections[indexPath.section].tasks + sections[indexPath.section+2].tasks
            count = 3
        }
        else{
            tmpTasks = sections[indexPath.section].tasks
            count = 2
        }
        
        for j in 0..<count{
            sections.remove(at: indexPath.section)
        }
        
        sections.insert(Section(tasks: tmpTasks, level: currentLevel), at: indexPath.section)

 
        
    }

    
    @IBAction func pressOkButton(){
        
        addTask()
        
    }
    
    func openCalendar(){
        
        diskey()
        datePicker.isHidden = false
        
    }
    
    func dismissKeyboard() {

        addTask()
        datePicker.isHidden = true
        
    }
    
    func diskey(){
        
        let indexPath = IndexPath(item: 0, section: 0)           //    dismiss keyboard
        let cell = cV.cellForItem(at: indexPath) as! AddTaskCell
        cell.textField.resignFirstResponder()
    }
    
    
    func addTask(){
        
        diskey()
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = cV.cellForItem(at: indexPath) as! AddTaskCell
        
        if (cell.textField.text != ""){
            
            let task = Task(name: cell.textField.text!)
            
            if (isSetDate){
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy hh:mm"
                task.date = formatter.string(from: datePicker.date)
                isSetDate = false
            }
            
            sections[0].tasks.insert(task, at: 1)
            cell.textField.text = ""
            cV.reloadData()
        }
        
    }
    
    func datePickerChanged(sender: UIDatePicker){
    
        isSetDate = true
        
    }
    
    
    
}




