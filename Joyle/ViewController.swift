//
//  ViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 06.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//


import UIKit

class ViewController: UIViewController{
    
    //DESIGN
    
    let colors: [UIColor] = [
        UIColor(red: 225/255.0, green: 253/255.0, blue: 238/255.0, alpha: 1.0),
        UIColor(red: 189/255.0, green: 245/255.0, blue: 217/255.0, alpha: 1.0),
        UIColor(red: 146/255.0, green: 236/255.0, blue: 190/255.0, alpha: 1.0),
        UIColor(red: 88/255.0, green: 224/255.0, blue: 155/255.0, alpha: 1.0),
        UIColor(red: 54/255.0, green: 205/255.0, blue: 128/255.0, alpha: 1.0)
    ]
    
    @IBOutlet var cV: UICollectionView!
    @IBOutlet var tV: UITableView!
    @IBOutlet var ok: UIBarButtonItem!
    @IBOutlet var topView: UIView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var underTopView: UIView!
    @IBOutlet var replaceView: UIView!
    @IBOutlet var groupsView: UIView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var blackView: UIView!
    @IBOutlet var groupView_checkButton: UIButton!
    @IBOutlet var groupView_label: UILabel!
    @IBOutlet var groupView_replaceLabel: UILabel!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var rightButton_image: UIImageView!
    
    let rectView: UIView = UIView()
    var views: [UIView] = []
    var currentCell: TaskCell!
    var dragView: UIView!
    var borderSublayer: CAShapeLayer!
    
    //CONTROLLER
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    var cvTasks: [Task] = []
    var finishedTasks: [Task] = []
    var groupsArray: [String] = []
    var tmpTask: Task!
    var isCopyTime: Bool = false
    var isSetDate: Bool = false
    var mainLevel: Int = 0
    var beginRow: Int!
    var destinationRow: Int!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        groupsArray = [
            "Инбокс",
            "Добавить группу",
            "Маркетинг Joyle",
            "Мобильная разработка альбомного сервиса",
            "Баку",
            "Владивосток"
        ]
        
        cvTasks = [
            Task(name: "Список горячих клавиш для веб версии"),
            Task(name: "Сделать уборку дома"),
            Task(name: "Прочитать заметку по уберизации"),
            Task(name: "Сходить на йогу"),
            Task(name: "Подготовить макеты для Joyle"),
            Task(name: "Скину все необходимые материалы для встречи Ирине"),
            Task(name: "Подготовить ТЗ для аналитика"),
            Task(name: "Назначить созвон с бухгалтерами"),
            Task(name: "Составить список по необходимым документам"),
            Task(name: "Передернуть"),
            Task(name: "Вынести мусор"),
            Task(name: "Позвонить Олегу")
        ]
        
        setupRectView()
        setupBorderSublayer()
        setupDragView()
        setupDragViewButton()
        setupDragViewLabel()
        setupButtons()
        setupLevelViews()
        setupUnderTopView()
        
        tV.separatorColor = .white
        groupsView.frame.origin = CGPoint(x: 0, y: -(groupsView.frame.size.height) - 50.0)
        groupsView.layer.shadowColor = UIColor.black.cgColor
        groupsView.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(4.0))
        groupsView.layer.shadowOpacity = 0.06
        groupsView.layer.shadowRadius = 10
        groupView_checkButton.layer.borderColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 1.0).cgColor
        groupView_checkButton.layer.borderWidth = 1.0
        groupView_checkButton.layer.cornerRadius = 3
        
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        cV.addGestureRecognizer(longPressGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cV.reloadData()
    }

    
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            
            beganDrag(gesture: gesture)
            break
            
        case UIGestureRecognizerState.changed:
            
            changedDrag(gesture: gesture)
            break
            
            
        case UIGestureRecognizerState.ended:
            
            endedDrag(gesture: gesture)
            break
            
        default:
            cV.cancelInteractiveMovement()
        
        }
    }
    
    @IBAction func closeGroupView(){
        closeGroupsView()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIScrollViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: collectionView.bounds.width - 20, height: 40)
        return itemSize
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cvTasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TaskCell
        
        
        cell.label.text = cvTasks[indexPath.row].name
        cell.checkButton.frame.origin.x = CGFloat(10 + 10*cvTasks[indexPath.row].level)
        cell.checkButton.layer.borderColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 1.0).cgColor
        cell.checkButton.layer.borderWidth = 1.0
        cell.checkButton.layer.cornerRadius = 3
        cell.label.frame.origin.x = CGFloat(10 + 14 + 10 + 10*cvTasks[indexPath.row].level)
        cell.label.frame.size.width = CGFloat(268 - cell.label.frame.origin.x)
        cell.plusImageView.frame.origin.x = cell.checkButton.frame.origin.x + 3
        changeArrow(cell: cell, isOpen: cvTasks[indexPath.row].isOpen, isParent: !cvTasks[indexPath.row].subtasks.isEmpty)
        
        cell.setNeedsLayout()
        
        return cell
        
    }
    

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        closeEmptyTask(from: sourceIndexPath.row)
        removeFromParent(from: sourceIndexPath.row)
        let temp = cvTasks.remove(at: sourceIndexPath.item)
        insertInParent(element: temp, at: destinationIndexPath.row)
        cvTasks.insert(temp, at: destinationIndexPath.row)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            if (cvTasks[indexPath.row].subtasks.count != 0 && cvTasks[indexPath.row].isOpen == false){
                openTask(indexPath: indexPath)
            }
                
            else if (cvTasks[indexPath.row].isOpen){
                closeTask(indexPath: indexPath)
            }
        
    }
    
    internal func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        /*let flag = sender as! Int
        var tmpParent: Task!
        if (cvTasks[indexPath.row].level > 0){
            tmpParent = cvTasks[indexPath.row].parent
        }
        //////////////////////Копирование задачи
        if (flag == 1){
            /////////////////Закрытие подзадач
            if (cvTasks[indexPath.row].isOpen){
                closeTask(indexPath: indexPath)
            }
            /////////////////Удаление из массива подзадач
            if (cvTasks[indexPath.row].level > 0){
                let indexOfA = tmpParent.subtasks.index(of: cvTasks[indexPath.row])
                tmpParent.subtasks.remove(at: indexOfA!)
            }
            ////////////////Удаление из массива задач
            tmpTask = cvTasks.remove(at: indexPath.row)
            
            ////////////////Удаление с анимацией
            cV.deleteItems(at: [indexPath])
            isCopyTime = true
            
        ///////////////////////Закрытие задачи
        } else if (flag == 2){
            /////////////////Закрытие подзадач
            if (cvTasks[indexPath.row].isOpen){
                closeTask(indexPath: indexPath)
            }
            cvTasks[indexPath.row].isFinish = true
            if (cvTasks[indexPath.row].level > 0){
                let indexOfA = tmpParent.subtasks.index(of: cvTasks[indexPath.row])
                tmpParent.subtasks.remove(at: indexOfA!)
            }
            finishedTasks.append(cvTasks.remove(at: indexPath.row))
            cV.deleteItems(at: [indexPath])
        //////////////////////Удаление задачи
        } else if (flag == 3){
            if (cvTasks[indexPath.row].isOpen){
                closeTask(indexPath: indexPath)
            }
            if (cvTasks[indexPath.row].level > 0){
                let indexOfA = tmpParent.subtasks.index(of: cvTasks[indexPath.row])
                tmpParent.subtasks.remove(at: indexOfA!)
            }
            cvTasks.remove(at: indexPath.row)
            cV.deleteItems(at: [indexPath])
            /////////////////Редактирование задачи
        } else if (flag == 4){
            let cell = collectionView.cellForItem(at: indexPath) as! TaskCell
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
            nextViewController.task = cvTasks[indexPath.row]
            nextViewController.indexPath = indexPath
            nextViewController.delegate = self
            self.present(nextViewController, animated:true, completion:nil)
            UIView.animate(withDuration: 0.2, animations: {
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
            })
        }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var edgeInsets = UIEdgeInsets()
        edgeInsets = UIEdgeInsetsMake(5,5,5,5)
        return edgeInsets;
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (cV.contentOffset.y > 0){
            underTopView.layer.shadowOpacity = 0.06
        }
        else{
            underTopView.layer.shadowOpacity = 0.0
        }
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return checkLabelFrame(string: groupsArray[indexPath.row]) + 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellGroup", for: indexPath) as! GroupCell
        
        switch indexPath.row{
        case 0: cell.icon.image = UIImage(named: "inbox")
                break
        case 1: cell.icon.image = UIImage(named: "add_folder")
                cell.label.textColor = UIColor(red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0)
                break
        default: cell.icon.image = UIImage(named: "folder-icon")
                 break
        }
        
        cell.label.text = groupsArray[indexPath.row]
        updateLabelFrame(label: cell.label)
        cell.selectionStyle = .none
        
        return GroupCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        closeGroupsView()
    }
    
}




