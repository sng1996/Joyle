//
//  ViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 06.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

// сделать insert в коллекцию, должно быть с анимацией
// свайп не по скорости а по длине
// think about deleteItems and deleteSections


import UIKit

class ViewController: UIViewController {
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    @IBOutlet var cV: UICollectionView!
    @IBOutlet var ok: UIBarButtonItem!
    @IBOutlet var datePicker: UIDatePicker!
    
    var cvTasks: [Task] = []
    var finishedTasks: [Task] = []
    var tmpTask: Task!
    var isCopyTime: Bool = false
    var isSetDate: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...10{
            let task = Task(name: "Task " + String(i))
            cvTasks.append(task)
        }
        
        ok.title = ""
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        cV.addGestureRecognizer(longPressGesture)

        
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cvTasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addTaskCell", for: indexPath) as! AddTaskCell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TaskCell
        
        if (indexPath.row == 0){
            
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
        
        cell.label.text = cvTasks[indexPath.row].name
        cell.labelDate.text = cvTasks[indexPath.row].date
        cell.labelStatus.text = ""
        
        switch(cvTasks[indexPath.row].level){
            
            case 0:
                cell.labelStatus.textColor = UIColor.black
                break
            case 1:
                cell.labelStatus.textColor = UIColor.red
                break
            case 2:
                cell.labelStatus.textColor = UIColor.blue
                break
            case 3:
                cell.labelStatus.textColor = UIColor.green
                break
            default: break
            
        }
        
        if (cvTasks[indexPath.row].level > 0){
            cell.labelStatus.text = "•"
        }
        
        if (cvTasks[indexPath.row].subtasks.count > 0){
            if(cvTasks[indexPath.row].isOpen){
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
        
        let taskTmp = cvTasks[destinationIndexPath.row]
        
        ///////////////Закрытие пустой задачи
        
        if (cvTasks[sourceIndexPath.row].level > 0 && cvTasks[sourceIndexPath.row].parent.subtasks.count == 1 && cvTasks[sourceIndexPath.row-1].parent.isOpen){
            cvTasks[sourceIndexPath.row-1].parent.isOpen = false
        }
        
        ///////////////Удаление из основного массива
        
        if (cvTasks[sourceIndexPath.row].level > 0){
            
            let indexOfA = cvTasks[sourceIndexPath.row].parent.subtasks.index(of: cvTasks[sourceIndexPath.row])
            cvTasks[sourceIndexPath.row].parent.subtasks.remove(at: indexOfA!)
            
        }
        /////////////////Удаление из списка
        
        let temp = cvTasks.remove(at: sourceIndexPath.item)
        
        /////////////////Вставка в основной массив
    
        if (destinationIndexPath.row < cvTasks.count){
            temp.level = taskTmp.level
            if (temp.level > 0){
                let indexOfA = taskTmp.parent.subtasks.index(of: taskTmp)
                taskTmp.parent.subtasks.insert(temp, at: indexOfA!)
            }
        }
        else{
            temp.level = 0
        }
        
        ///////////////Вставка в список
        temp.parent = taskTmp.parent
        cvTasks.insert(temp, at: destinationIndexPath.row)
        //cV.reloadData()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (isCopyTime){
            /////////////////////////////////////////////Копирование в задачу
            tmpTask.parent = cvTasks[indexPath.row]
            cvTasks[indexPath.row].subtasks.append(tmpTask)
            cV.reloadData()
            isCopyTime = false
        }
        else{
            /////////////////////////////////////////////Открытие задачи
            if (cvTasks[indexPath.row].subtasks.count != 0 && cvTasks[indexPath.row].isOpen == false){
                cvTasks[indexPath.row].isOpen = true
                let cell = cV.cellForItem(at: indexPath) as! TaskCell
                cell.labelStatus.text = "V"
                /////////////////Вставка ряда подзадач
                for element in 0..<cvTasks[indexPath.row].subtasks.count{
                    cvTasks[indexPath.row].subtasks[element].level = cvTasks[indexPath.row].level + 1
                    cvTasks.insert(cvTasks[indexPath.row].subtasks[element], at: indexPath.row + element + 1)
                    collectionView.insertItems(at: [IndexPath(item: indexPath.row + element + 1, section: 0)])
                }
            }
                
            else if (cvTasks[indexPath.row].isOpen){
                
                closeTask(indexPath: indexPath)
                
            }
        }
        
    }
    
    internal func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        let flag = sender as! Int
        var tmpParent: Task!
        var isOpenTmp: Bool = false
        if (cvTasks[indexPath.row].level > 0){
            tmpParent = cvTasks[indexPath.row].parent
        }
        //////////////////////Копирование задачи
        if (flag == 1){
            /////////////////Закрытие подзадач
            if (cvTasks[indexPath.row].isOpen){
                closeTask(indexPath: indexPath)
                isOpenTmp = true
            }
            /////////////////Удаление из массива подзадач
            if (cvTasks[indexPath.row].level > 0){
                let indexOfA = tmpParent.subtasks.index(of: cvTasks[indexPath.row])
                tmpParent.subtasks.remove(at: indexOfA!)
            }
            ////////////////Удаление из массива задач
            tmpTask = cvTasks.remove(at: indexPath.row)
            
            ////////////////Удаление с анимацией
            if (!isOpenTmp){
                cV.deleteItems(at: [indexPath])
            }
            cV.reloadData()
            isCopyTime = true
            
            
        ///////////////////////Закрытие задачи
        } else if (flag == 2){
            /////////////////Закрытие подзадач
            if (cvTasks[indexPath.row].isOpen){
                closeTask(indexPath: indexPath)
                isOpenTmp = true
            }
            cvTasks[indexPath.row].isFinish = true
            if (cvTasks[indexPath.row].level > 0){
                let indexOfA = tmpParent.subtasks.index(of: cvTasks[indexPath.row])
                tmpParent.subtasks.remove(at: indexPath.row)
            }
            finishedTasks.append(cvTasks.remove(at: indexPath.row))
            if (!isOpenTmp){
                cV.deleteItems(at: [indexPath])
            }
            cV.reloadData()
        //////////////////////Удаление задачи
        } else if (flag == 3){
            if (cvTasks[indexPath.row].isOpen){
                closeTask(indexPath: indexPath)
                isOpenTmp = true
            }
            if (cvTasks[indexPath.row].level > 0){
                tmpParent.subtasks.remove(at: indexPath.row)
            }
            cvTasks.remove(at: indexPath.row)
            if (!isOpenTmp){
                cV.deleteItems(at: [indexPath])
            }
            cV.reloadData()
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
        cell.labelStatus.text = ">"

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
            
            cvTasks.insert(task, at: 1)
            cell.textField.text = ""
            cV.reloadData()
        }
        
    }
    
    func datePickerChanged(sender: UIDatePicker){
    
        isSetDate = true
        
    }
    
    /*func findElement(array: [Task], object: Task) -> Int{
        
        for i in 0..<array.count{
            if(array[i] == object){
                return i
            }
        }
        
    }*/
    
    
}




