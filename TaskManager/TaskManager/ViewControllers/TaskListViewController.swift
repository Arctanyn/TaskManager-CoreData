//
//  TaskListViewController.swift
//  TaskManager
//
//  Created by Малиль Дугулюбгов on 10.02.2022.
//

import UIKit

private let reuseCellIdentifier = TaskCell.identifier

class TaskListViewController: UIViewController {
    
    //MARK: Properties
    
    private var assignedTasks = [AssignedTask]() {
        didSet {
            noCurrentTasksLabel.isHidden = !assignedTasks.isEmpty
            setEnableForDeleteAllButton()
        }
    }
    
    //MARK: - View
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteAllTasksButton: UIBarButtonItem!
    @IBOutlet weak var noCurrentTasksLabel: UILabel!
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchTasks()
        setEnableForDeleteAllButton()
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let navigationController = segue.destination as? UINavigationController,
            let taskInfoVC = navigationController.topViewController as? TaskInfoViewController
        else { return }
        taskInfoVC.saveTaskDelegate = self
        if segue.identifier == "editTask" {
            guard
                let indexPath = tableView.indexPathForSelectedRow else { return }
            taskInfoVC.task = assignedTasks[indexPath.row]
        }
    }
    
    //MARK: - IBAtions
    
    @IBAction func deleteAllTasks(_ sender: UIBarButtonItem) {
        showDeleteAllAlert()
    }
    
    //MARK: - Private methods
    
    private func fetchTasks() {
        guard let tasks = StorageManager.shared.fetchData() else { return }
        for task in tasks {
            let assignedTask = AssignedTask(
                name: task.name ?? "Новая задача",
                description: task.taskDescription,
                priority: AssignedTaskPriority(rawValue: task.priority ?? "") ?? .standard,
                date: task.date,
                url: task.url,
                isHaveActiveDate: task.isHaveActiveDate,
                isHaveActiveTime: task.isHaveActiveTime
            )
            assignedTasks.insert(assignedTask, at: 0)
        }
    }
    
    private func setEnableForDeleteAllButton() {
        deleteAllTasksButton.isEnabled = !assignedTasks.isEmpty
    }
    
    private func deleteTask(at indexPath: IndexPath) {
        let deletingTask = assignedTasks[indexPath.row]
        StorageManager.shared.delete(task: deletingTask)
        assignedTasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    private func showDeleteAllAlert() {
        let alert = UIAlertController(
            title: "Это действие приведет к удалению всех ваших задач",
            message: "Вы действительно хотите это сделать?",
            preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            StorageManager.shared.deleteAll()
            self?.assignedTasks.removeAll()
            self?.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
}

//MARK: - UITableViewDataSource

extension TaskListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier, for: indexPath) as! TaskCell
        let task = assignedTasks[indexPath.row]
        cell.setup(with: task)
        cell.deleteCellDelegate = self
        return cell
    }
}

//MARK: - UITableViewDelegate

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = deleteSwipeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func deleteSwipeAction(at indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, completion in
            self?.deleteTask(at: indexPath)
            completion(true)
        }
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash")
        return deleteAction
    }
}

//MARK: - TaskListViewControllerDelegate

extension TaskListViewController: TaskListViewControllerDelegate {
    func save(task: AssignedTask, process: SaveProcess) {
        switch process {
        case .add:
            let indexPath = IndexPath(row: 0, section: 0)
            assignedTasks.insert(task, at: 0)
            StorageManager.shared.save(task)
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .edit:
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let oldTask = assignedTasks[indexPath.row]
            StorageManager.shared.update(
                task: oldTask,
                to: task
            )
            assignedTasks[indexPath.row] = task
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func deleteCell(at locaton: CGPoint) {
        guard let indexPath = tableView.indexPathForRow(at: locaton) else { return }
        deleteTask(at: indexPath)
    }
}
