//
//  CalendarView.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 23.11.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarView: UIView {

    @IBOutlet var calendarView: UIView!
    @IBOutlet var cV: JTAppleCalendarView!
    @IBOutlet var todayButton: UIButton!
    @IBOutlet var tomorrowButton: UIButton!
    @IBOutlet var nextWeekButton: UIButton!
    @IBOutlet var addNotificationButton: UIButton!
    @IBOutlet var daysView: UIView!
    
    let daysOfWeek = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nib = UINib(nibName: "CalendarView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        
        let gap = (daysView.frame.size.width - 30*7)/6
        for i in 0..<7{
            let button = UIButton(frame: CGRect(x: CGFloat(i)*(30.0+gap), y: 0, width: 30, height: 30))
            button.setTitle(daysOfWeek[i], for: .normal)
            button.setTitleColor(UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0), for: .normal)
            button.titleLabel?.font =  UIFont(name: "MuseoSansCyrl-500", size: 14)
            button.layer.cornerRadius = 5
            button.layer.borderColor = UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0).cgColor
            button.layer.borderWidth = 1.0
            button.addTarget(self, action: #selector(pressDaysButton(sender:)), for: .touchUpInside)
            daysView.addSubview(button)
        }
        
        todayButton.layer.cornerRadius = 5
        todayButton.layer.borderColor = UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0).cgColor
        todayButton.layer.borderWidth = 1.0
        tomorrowButton.layer.cornerRadius = 5
        tomorrowButton.layer.borderColor = UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0).cgColor
        tomorrowButton.layer.borderWidth = 1.0
        nextWeekButton.layer.cornerRadius = 5
        nextWeekButton.layer.borderColor = UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0).cgColor
        nextWeekButton.layer.borderWidth = 1.0
        addNotificationButton.layer.cornerRadius = 5
        addNotificationButton.layer.borderColor = UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0).cgColor
        addNotificationButton.layer.borderWidth = 1.0
        
        addNotificationButton.setImage(UIImage(named: "notification_grey"), for: .normal)
        addNotificationButton.setTitle("Добавить напоминание", for: .normal)
        addNotificationButton.setTitleColor(UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0), for: .normal)
        addNotificationButton.titleLabel?.font =  UIFont(name: "MuseoSansCyrl-300", size: 14)
        addNotificationButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
        
        addSubview(calendarView)
        calendarView.frame = self.bounds
        
    }
    
    @IBAction func pressButton(sender: UIButton){
        
        if sender.layer.borderColor == UIColor(red: 67/255.0, green: 191/255.0, blue: 128/255.0, alpha: 1.0).cgColor{
            sender.layer.borderColor = UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0).cgColor
            sender.setTitleColor(UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0), for: .normal)
        }
        else{
            sender.layer.borderColor = UIColor(red: 67/255.0, green: 191/255.0, blue: 128/255.0, alpha: 1.0).cgColor
            sender.setTitleColor(UIColor(red: 67/255.0, green: 191/255.0, blue: 128/255.0, alpha: 1.0), for: .normal)
        }
        
    }
    
    func pressDaysButton(sender: UIButton){
        
        if sender.layer.borderColor == UIColor(red: 67/255.0, green: 191/255.0, blue: 128/255.0, alpha: 1.0).cgColor{
            sender.layer.borderColor = UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0).cgColor
            sender.setTitleColor(UIColor(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 1.0), for: .normal)
        }
        else{
            sender.layer.borderColor = UIColor(red: 67/255.0, green: 191/255.0, blue: 128/255.0, alpha: 1.0).cgColor
            sender.setTitleColor(UIColor(red: 67/255.0, green: 191/255.0, blue: 128/255.0, alpha: 1.0), for: .normal)
        }
        
    }

}
