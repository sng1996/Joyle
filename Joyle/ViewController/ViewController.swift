//
//  ViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 06.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//


import UIKit
import JTAppleCalendar

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
    @IBOutlet var ok: UIBarButtonItem!
    @IBOutlet var topView: UIView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var underTopView: UIView!
    @IBOutlet var replaceView: UIView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var blackView: UIView!
    @IBOutlet var rightButton_image: UIImageView!
    @IBOutlet var calendarView: CalendarView!
    @IBOutlet var groupsView: GroupsView!
    @IBOutlet var addNotificationView: AddNotificationView!
    @IBOutlet var secondBlackView: UIView!
    @IBOutlet var moreView: UIView!
    
    @IBOutlet var more_checkButton: UIButton!
    @IBOutlet var more_header: UILabel!
    @IBOutlet var more_note: UITextViewPlaceholder!
    @IBOutlet var more_tagsView: UIView!
    @IBOutlet var more_tV: UITableView!
    @IBOutlet var more_calendarButton: UIButton!
    @IBOutlet var more_notificationButton: UIButton!
    @IBOutlet var more_tagButton: UIButton!
    @IBOutlet var more_listButton: UIButton!
    @IBOutlet var more_messageButton: UIButton!
    @IBOutlet var more_scrollView: UIScrollView!
    @IBOutlet var more_iconsView: UIView!
    
    
    let rectView: UIView = UIView()
    var views: [UIView] = []
    var currentCell: TaskCell!
    var dragView: UIView!
    var borderSublayer: CAShapeLayer!
    var isNotificationOpen: Bool = false
    
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
    var formatter = DateFormatter()
    var checkPoints: [String] = ["kek", "kek", "kek", "kek"]
    
    

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
        setupGroupsView()
        setupCalendarView()
        setupCalendarCell()
        setupAddNotificationView()
        setupGroupsCell()
        
        /*let moreCellNib = UINib(nibName: "MoreCell", bundle: nil)
        moreView.cV.register(moreCellNib, forCellWithReuseIdentifier: "moreCell")
        let moreNoteCellNib = UINib(nibName: "MoreNoteCell", bundle: nil)
        moreView.cV.register(moreNoteCellNib, forCellWithReuseIdentifier: "moreNoteCell")
        let moreAddPointCellNib = UINib(nibName: "MoreAddPointCell", bundle: nil)
        moreView.cV.register(moreAddPointCellNib, forCellWithReuseIdentifier: "moreAddPointCell")
        
        moreView.cV.delegate = self
        moreView.cV.dataSource = self*/
        
        moreView.layer.shadowRadius = 4
        moreView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        moreView.layer.shadowOpacity = 0.15
        moreView.layer.shadowOffset = CGSize(width: 0, height: 2)
        more_checkButton.layer.borderColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 1.0).cgColor
        more_checkButton.layer.borderWidth = 1.0
        more_checkButton.layer.cornerRadius = 3
        more_calendarButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10.0)
        more_note.isScrollEnabled = false
        more_note.placeholder = "Добавить заметку"
        more_scrollView.contentSize.height = 500.0
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        customView.backgroundColor = UIColor.white
        let more_calendarButton_copy = UIButton(frame: CGRect(x: 5, y: 6, width: 135, height: 32))
        more_calendarButton_copy.backgroundColor = UIColor(red: 252/255.0, green: 252/255.0, blue: 252/255.0, alpha: 1.0)
        more_calendarButton_copy.setImage(UIImage(named: "calendar_grey"), for: .normal)
        more_calendarButton_copy.setTitle("Пн. 12 октября", for: .normal)
        customView.addSubview(more_calendarButton_copy)
        more_note.inputAccessoryView = customView
        more_note.inputAccessoryView?.isHidden = true
        
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
    
    @IBAction func pressCloseCalendarView(){
        if (!isNotificationOpen){
            closeCalendarView()
        }
    }
    
    @IBAction func pressCloseNotificationView(){
        closeNotificationView()
        isNotificationOpen = false
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIScrollViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //if (collectionView == cV){
            let itemSize = CGSize(width: collectionView.bounds.width - 20, height: 40)
            return itemSize
        /*}
        else{
            let itemSize = CGSize(width: collectionView.bounds.width - 20, height: 28)
            return itemSize
        }*/
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if (collectionView == cV){
            return cvTasks.count
        /*}
        else{
            return checkPoints.count + 2
        }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //if (collectionView == cV){
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
        //}
        /*else{
            if (indexPath.row == 0){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreNoteCell", for: indexPath) as! MoreNoteCell
                cell.textView.placeholder = "Добавить заметку"
                cell.frame.size.height = cell.textView.frame.size.height
                return cell
            }
            else if (indexPath.row == 1){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreAddPointCell", for: indexPath) as! MoreAddPointCell
                cell.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
                cell.layer.cornerRadius = 3
                return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreCell", for: indexPath) as! MoreCell
                cell.label.text = checkPoints[indexPath.row-2]
                return cell
            }
        }*/
        
    }
    

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        closeEmptyTask(from: sourceIndexPath.row)
        removeFromParent(from: sourceIndexPath.row)
        let temp = cvTasks.remove(at: sourceIndexPath.item)
        insertInParent(element: temp, at: destinationIndexPath.row)
        cvTasks.insert(temp, at: destinationIndexPath.row)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            /*if (cvTasks[indexPath.row].subtasks.count != 0 && cvTasks[indexPath.row].isOpen == false){
                openTask(indexPath: indexPath)
            }
                
            else if (cvTasks[indexPath.row].isOpen){
                closeTask(indexPath: indexPath)
            }*/
        cV.contentOffset = CGPoint(x: 0, y: 0)
        let cell = collectionView.cellForItem(at: indexPath) as? TaskCell
        let rect = cell?.frame
        let cellFrameInSuperview: CGRect! = cV.convert(rect!, to: cV.superview)
        var targetY = cellFrameInSuperview.origin.y
        if (cellFrameInSuperview.origin.y > (self.view.frame.size.height - 60.0 - moreView.frame.size.height)){
            targetY = self.view.frame.size.height - 60.0 - moreView.frame.size.height
            let currentY = cellFrameInSuperview.origin.y
            cV.contentOffset = CGPoint(x: 0, y: currentY - targetY)
        }
        moreView.frame.origin.y = targetY
        moreView.isHidden = false
        
    }
    
    internal func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        let index = sender as! Int
        if index == 2{
            openCalendarView()
        }
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
        if (tableView == more_tV){
            return 28
        }
        else{
            let label = UILabel()
            label.text = groupsArray[indexPath.row]
            label.font = UIFont(name: "MuseoSansCyrl-300", size: 16)
            return checkLabelFrame(label: label) + 20
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == more_tV){
            return checkPoints.count
        }
        else{
            return groupsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == more_tV){
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath) as! MoreCell
            cell.label.text = checkPoints[indexPath.row]
            tableView.frame.size.height = tableView.contentSize.height
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell

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
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        closeGroupsView()
    }
    
}

extension ViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters{
        formatter.dateFormat = "dd MM yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "01 11 2017")
        let endDate = formatter.date(from: "01 01 2020")
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        cell.selectedView.layer.cornerRadius = 5
        setColorToDate(cell: cell, cellState: cellState)
        
        return cell
    }
    
    func setColorToDate(cell: CalendarCell, cellState: CellState){
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        cell.selectedView.isHidden = true
        if dateFormatter.string(from: cellState.date) == dateFormatter.string(from: Date()){
            cell.dateLabel.textColor = UIColor(red: 67/255.0, green: 191/255.0, blue: 128/255.0, alpha: 1.0)
        }
        else{
            cell.dateLabel.textColor = UIColor(red: 191/255.0, green: 191/255.0, blue: 191/255.0, alpha: 1.0)
        }
        
        if cellState.dateBelongsTo != .thisMonth{
            cell.dateLabel.textColor = UIColor(red: 191/255.0, green: 191/255.0, blue: 191/255.0, alpha: 0.13)
        }
        
        if (cellState.isSelected && cellState.dateBelongsTo == .thisMonth){
            cell.dateLabel.textColor = .white
            cell.selectedView.isHidden = false
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else {return}
        setColorToDate(cell: validCell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else {return}
        setColorToDate(cell: validCell, cellState: cellState)
    }
    
}




