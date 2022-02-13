//
//  TaskPriorityViewController.swift
//  TaskManager
//
//  Created by Малиль Дугулюбгов on 12.02.2022.
//

import UIKit

private let reuseIdentifier = TaskPriorityCell.identifier

class TaskPriorityViewController: UITableViewController {
    
    //MARK: Properties
    var taskPrioriy: AssignedTaskPriority!
    private var priorities = AssignedTaskPriority.allCases
    weak var changePriorityDelegate: TaskInfoViewControllerDelegate?

    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Приоритет"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priorities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TaskPriorityCell
        
        let priority = priorities[indexPath.row]
        cell.setup(with: priority)
        
        if taskPrioriy == priority {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPriority = priorities[indexPath.row]
        changePriorityDelegate?.changePriority(to: selectedPriority)
        taskPrioriy = selectedPriority
        navigationController?.popViewController(animated: true)
    }
}
