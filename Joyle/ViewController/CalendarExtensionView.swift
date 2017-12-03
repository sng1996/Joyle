//
//  CalendarExtensionView.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 02.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit
import JTAppleCalendar

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
