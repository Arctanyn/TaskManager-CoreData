//
//  AssignedTask.swift
//  TaskManager
//
//  Created by Малиль Дугулюбгов on 10.02.2022.
//

import Foundation

enum AssignedTaskPriority: String, CaseIterable {
    case standard = "Обычный"
    case important = "Важный"
    
    var description: String {
        switch self {
        case .standard:
            return PriorityDescription.standard.rawValue
        case .important:
            return PriorityDescription.important.rawValue
        }
    }
    
    enum PriorityDescription: String {
        case standard = "Обычная задача"
        case important = "Такая задача имеет приоритет выше обычной задачи"
    }
}

struct AssignedTask {
    
    //MARK: Properties
    
    var name: String
    var description: String?
    var priority: AssignedTaskPriority
    var date: Date?
    var url: String?
    var isHaveActiveDate: Bool
    var isHaveActiveTime: Bool
    
    //MARK: - Methods
    
    static func ==(lhs: AssignedTask, rhs: AssignedTask) -> Bool {
        guard
            lhs.name == rhs.name,
            lhs.description == rhs.description,
            lhs.priority == rhs.priority,
            lhs.url == rhs.url,
            lhs.date == rhs.date
        else { return false }
        return true
    }
}
