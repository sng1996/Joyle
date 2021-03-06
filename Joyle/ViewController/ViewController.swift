//
//  ViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 06.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//


import UIKit
import JTAppleCalendar
import SQLite

extension UIButton
{
    func copyView<T: UIButton>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
}

class ViewController: UIViewController{
    
    //DESIGN
    
    let colors: [UIColor] = [
        UIColor(red: 225/255.0, green: 253/255.0, blue: 238/255.0, alpha: 1.0),
        UIColor(red: 189/255.0, green: 245/255.0, blue: 217/255.0, alpha: 1.0),
        UIColor(red: 146/255.0, green: 236/255.0, blue: 190/255.0, alpha: 1.0),
        UIColor(red: 88/255.0, green: 224/255.0, blue: 155/255.0, alpha: 1.0),
        UIColor(red: 54/255.0, green: 205/255.0, blue: 128/255.0, alpha: 1.0)
    ]
    
    //DB
    //tasks
    let tasksTable = Table("tasks")
    let id_tasks = Expression<String>("id")
    let name_tasks = Expression<String>("name")
    let description_tasks = Expression<String>("description")
    let date_tasks = Expression<String>("date")
    let creator_id_tasks = Expression<String>("creator_id")
    
    //task_items
    let task_itemsTable = Table("task_items")
    let id_task_items = Expression<String>("id")
    let task_id_task_items = Expression<String>("task_id")
    let group_id_task_items = Expression<String>("group_id")
    let parent_id_task_items = Expression<String>("parent_id")
    let is_open_task_items = Expression<Bool>("is_open")
    let priority_task_items = Expression<Int>("priority")
    let delegated_to_user_id_task_items = Expression<String>("delegated_to_user_id")
    let delegated_from_user_id_task_items = Expression<String>("delegated_from_user_id")
    let position_task_items = Expression<Int>("position")
    
    @IBOutlet var cV: UICollectionView!
    @IBOutlet var ok: UIBarButtonItem!
    @IBOutlet var topView: UIView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var underTopView: UIView!
    @IBOutlet var replaceView: UIView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var rightButton_image: UIImageView!
    @IBOutlet var addNotificationView: AddNotificationView!
    @IBOutlet var moreView: UIView!
    
    @IBOutlet var more_titleView: UIView!
    @IBOutlet var more_checkButton: UIButton!
    @IBOutlet var more_header: UILabel!
    @IBOutlet var more_note: UITextViewPlaceholder!
    @IBOutlet var more_tagsView: UIView!
    @IBOutlet var more_tV: UITableView!
    @IBOutlet var more_scrollView: UIScrollView!
    @IBOutlet var more_iconsView: UIView!
    @IBOutlet var more_iconsScrollView: UIScrollView!
    @IBOutlet var more_leftView: UIView!
    @IBOutlet var more_rightView: UIView!
    @IBOutlet var blackButton: UIButton!
    @IBOutlet var secondBlackButton: UIButton!
    @IBOutlet var generalView: UIView!
    
    let rectView: UIView = UIView()
    var views: [UIView] = []
    var currentCell: TaskCell!
    var dragView: UIView!
    var borderSublayer: CAShapeLayer!
    var tV_textField: UITextField! = UITextField()
    var customView: UIView!
    var isKeyboardOpen: Bool = false
    
    let bottomMargin: CGFloat = 60.0
    let scrollBottomMargin: CGFloat = 47.0
    let iconsViewY_fromBottom: CGFloat = 37.0
    let topMargin: CGFloat = 20.0
    var myKeyboardHeight: Int = 0
    var cellH: CGFloat = 28.0
    
    var isViewOpen: Int = 0 // 1 - calendar; 2 - notification; 3 - more; 4 - replace
    
    //CONTROLLER
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    var cvTasks: [Task] = []
    var finishedTasks: [Task] = []
    var tmpTask: Task!
    var isCopyTime: Bool = false
    var isSetDate: Bool = false
    var mainLevel: Int = 0
    var beginRow: Int!
    var destinationRow: Int!
    var formatter = DateFormatter()
    var checkPoints: [String] = []
    var tags: [String] = ["Мой", "Дядя", "Самых честных", "Правил"]
    var allTasks: [Task] = []
    var groups: [Group] = []
    var groupIndex: Int!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        /*groupsArray = [
            "Инбокс",
            "Добавить группу",
            "Маркетинг Joyle",
            "Мобильная разработка альбомного сервиса",
            "Баку",
            "Владивосток"
        ]*/
        
        /*cvTasks = [
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
        ]*/
        
        print(groups[groupIndex].id)
        
        setupRectView()
        setupBorderSublayer()
        setupDragView()
        setupDragViewButton()
        setupDragViewLabel()
        setupButtons()
        setupLevelViews()
        setupUnderTopView()
        setupAddNotificationView()
        
        moreView.layer.shadowRadius = 4
        moreView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        moreView.layer.shadowOpacity = 0.15
        moreView.layer.shadowOffset = CGSize(width: 0, height: 2)
        more_checkButton.layer.borderColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 1.0).cgColor
        more_checkButton.layer.borderWidth = 1.0
        more_checkButton.layer.cornerRadius = 3
        more_note.isScrollEnabled = false
        more_note.placeholder = "Добавить заметку"
        createCustomView()
        more_note.inputAccessoryView = customView
        more_note.inputAccessoryView?.isHidden = true
        
        createTagsView()
        
        let moreAddPointCellNib = UINib(nibName: "MoreAddPointCell", bundle: nil)
        more_tV.register(moreAddPointCellNib, forCellReuseIdentifier: "moreAddPointCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        cV.addGestureRecognizer(longPressGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createTable_tasks()
        createTable_task_items()
        updateData_tasks()
        getTaskItems_API()
        getTasks_API()
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
    
    @IBAction func closeView(){
        
        switch (isViewOpen){
        case 1: closeCalendarView()
                break
        case 2: closeNotificationView()
                break
        case 3: closeMoreView()
                break
        case 4: closeGroupsView()
                break
        default: break
        }
        
        isViewOpen = 0
        
    }
    
    func closeMoreView(){
        
        moreView.isHidden = true
        changeButton(toRed: false)
        cvTasks[moreView.tag].note = more_note.text
        
    }
    
    func openMoreView(indexPath: IndexPath, collectionView: UICollectionView){
        isViewOpen = 3
        cV.contentOffset = CGPoint(x: 0, y: 0)
        //more_note.text = cvTasks[indexPath.row].note
        let cell = collectionView.cellForItem(at: indexPath) as? TaskCell
        let rect = cell?.frame
        let cellFrameInSuperview: CGRect! = cV.convert(rect!, to: cV.superview)
        var targetY = cellFrameInSuperview.origin.y
        moreView.frame.origin.y = targetY
        moreView.isHidden = false
        moreView.tag = indexPath.row
        changeButton(toRed: true)
        openMoreView()
    }
    
    func keyBoardWillShow(notification: NSNotification) {
        isKeyboardOpen = true
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height - 44.0
            more_note.tag = Int(keyboardHeight)
            myKeyboardHeight = Int(keyboardHeight)
        }
        
        openKeyboard(keyboardH: CGFloat(more_note.tag))
    }
    
    func keyBoardWillHide(notification: NSNotification) {
        isKeyboardOpen = false
        closeKeyboard()
    }
    
    func dismissKeyboard(){
        more_note.resignFirstResponder()
    }
    
    func addTags(){
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AddTagsViewController") as! AddTagsViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
}







