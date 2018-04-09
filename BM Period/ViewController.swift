//
//  ViewController.swift
//  BM Period
//
//  Created by Jimmy Higuchi on 3/19/18.
//  Copyright © 2018 Jimmy Higuchi. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    
    @IBOutlet weak var monthYearLabel: UILabel!
    
    
    let outsideMonthColor = UIColor.lightGray
    let monthColor = UIColor.black
    let selectedMonthColor = UIColor.black
    let currentDateSelectedViewColor = UIColor.yellow
    let todayTextColor = UIColor.red
    let selectedDateColor = UIColor.white

    let formatter = DateFormatter()
    @IBOutlet weak var calendarView: JTAppleCalendarView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarView()
        
    }
    
    func setupCalendarView() {
        
        // setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // view load with current month
        calendarView.scrollToDate(Date())
       
        // allow multiple selections
        calendarView.allowsMultipleSelection = true
        
        // setup labels
        calendarView.visibleDates { (visibleDates) in
            let date = visibleDates.monthDates.first!.date
            
            self.formatter.dateFormat = "MMMM yyyy"
            self.monthYearLabel.text = self.formatter.string(from: date)
        }
        

    }
    
    
    
    func handleCellTextColor(view: JTAppleCell, cellState: CellState) {
        guard let validCell = view as? MyCustomCell else {return}
        
        // create as strings to avoid hours min sec
        formatter.dateFormat = "MMMM dd yyyy"
        let todaysDate = formatter.string(from: Date())
        let monthDayYear = formatter.string(from: cellState.date)
       
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if todaysDate == monthDayYear  {
                validCell.dateLabel.textColor = todayTextColor
            }
            else if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell, cellState: CellState) {
        guard let validCell = view as? MyCustomCell else {return}
        
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
            validCell.dateLabel.textColor = selectedDateColor
            
        } else {
            validCell.selectedView.isHidden = true
            validCell.dateLabel.textColor = monthColor
            
        }
    }
}

// protocols
extension ViewController: JTAppleCalendarViewDataSource {
   
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        //set the date format
        formatter.dateFormat = "MM dd yyyy"
        formatter.timeZone =  Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
       
        
        let startDate = formatter.date(from: "01 01 2017")!
        let endDate = formatter.date(from: "12 31 2020")!
        let outDate = OutDateCellGeneration.tillEndOfRow
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, generateOutDates: outDate)
        return parameters
        
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // This function should have the same code as the cellForItemAt function
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "MyCustomCell", for: indexPath) as! MyCustomCell
        cell.dateLabel.text = cellState.text
    }
    
}

extension ViewController: JTAppleCalendarViewDelegate {
    
    // displays the cells
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "MyCustomCell", for: indexPath) as! MyCustomCell
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        cell.dateLabel.text = cellState.text
        return cell
    }
    
    // selecting cell
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? MyCustomCell else {return}
        
        handleCellSelected(view: validCell, cellState: cellState)
    }
    
    // deselecting cell
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? MyCustomCell else {return}

        handleCellSelected(view: validCell, cellState: cellState)
    }
    
    // month and year labels updated
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "MMMM yyyy"
        monthYearLabel.text = formatter.string(from: date)
    }
}

//building your own hexcolor
extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
