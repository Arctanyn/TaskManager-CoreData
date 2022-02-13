//
//  TaskPriorityCell.swift
//  TaskManager
//
//  Created by Малиль Дугулюбгов on 12.02.2022.
//

import UIKit

class TaskPriorityCell: UITableViewCell {
    
    //MARK: Properties
    
    static let identifier = "TaskPriorityCell"

    //MARK: - IBOutlets
    
    @IBOutlet weak var priorityNameLabel: UILabel!
    @IBOutlet weak var priorytyDescriptionLabel: UILabel!
    
    //MARK: - Methods
    
    func setup(with priority: AssignedTaskPriority) {
        priorityNameLabel.text = priority.rawValue
        priorytyDescriptionLabel.text = priority.description
    }
    
}
