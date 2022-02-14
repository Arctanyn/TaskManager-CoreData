//
//  DateManager.swift
//  TaskManager
//
//  Created by Малиль Дугулюбгов on 12.02.2022.
//

import Foundation

class DateManager {
    
    //MARK: Properties
    private let calendar = Calendar.current
    private var authomaticTimeComponents: DateComponents
    
    //MARK: - Initialization
    
    init() {
        authomaticTimeComponents = DateComponents(
            calendar: calendar,
            hour: 12,
            minute: 0
        )
    }
    
    //MARK: - Methods
    
    func setDefaultTime(for date: Date) -> Date {
        var newDate = date
        let taskDateComponets = calendar.dateComponents([.day, .month, .year], from: date)
        newDate = calendar.date(
            from: DateComponents(
                calendar: calendar,
                year: taskDateComponets.year,
                month: taskDateComponets.month,
                day: taskDateComponets.day,
                hour: authomaticTimeComponents.hour,
                minute: authomaticTimeComponents.minute,
                second: authomaticTimeComponents.second
            )
        ) ?? Date()
        return newDate
    }
    
}
