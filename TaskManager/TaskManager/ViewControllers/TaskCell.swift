//
//  TaskCell.swift
//  TaskManager
//
//  Created by Малиль Дугулюбгов on 10.02.2022.
//

import UIKit

class TaskCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "TaskCell"
    weak var deleteCellDelegate: TaskListViewControllerDelegate?

    //MARK: - View
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var completeTaskButton: UIButton!
    @IBOutlet weak var taskDateLabel: UILabel!
    
    //MARK: - Methods
    
    func setup(with task: AssignedTask) {
        taskNameLabel.textColor = .label
        taskNameLabel.text = task.name
        
        taskDateLabel.textColor = .darkGray
        if let taskDate = task.date {
            var dateString = taskDate.dateToString() + " "
            if task.isHaveActiveTime {
                dateString += taskDate.timeToString()
            }
            taskDateLabel.text = dateString
        } else {
            taskDateLabel.text = ""
        }
        
        setupPriorityLabel(with: task.priority)
        
        completeTaskButton.setImage(UIImage(systemName: "circle"), for: .normal)
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(completeTaskButtonTapGesture(_:))
        )
        completeTaskButton.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Actions
    
    @objc private func completeTaskButtonTapGesture(_ sender: UITapGestureRecognizer) {
        updateUIForCompleteAction()
        let location = sender.location(in: superview)
        print(location)
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { [deleteCellDelegate] _ in
            deleteCellDelegate?.deleteCell(at: location)
        }
    }
    
    //MARK: - Private methods
    
    private func setupPriorityLabel(with priority: AssignedTaskPriority) {
        switch priority {
        case .standard:
            taskPriorityLabel.textColor = .darkGray
        case .important:
            taskPriorityLabel.textColor = .systemRed
        }
        taskPriorityLabel.text = priority.rawValue
    }
    
    private func updateUIForCompleteAction() {
        taskNameLabel.textColor = .lightGray
        taskDateLabel.textColor = .lightGray
        taskPriorityLabel.textColor = .lightGray
        completeTaskButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
    }
}
