//
//  TaskViewController.swift
//  TaskManager
//
//  Created by Малиль Дугулюбгов on 10.02.2022.
//

import UIKit

enum SaveProcess {
    case add
    case edit
}

protocol TaskInfoViewControllerDelegate: AnyObject {
    func changePriority(to priority: AssignedTaskPriority) -> Void
}

class TaskInfoViewController: UITableViewController {
    
    //MARK: Properties
    
    weak var saveTaskDelegate: TaskListViewControllerDelegate?
    private let dateManager = DateManager()
    private var priority: AssignedTaskPriority = .standard {
        didSet {
            taskPriorityLabel.text = priority.rawValue
            setAccessToSaveButton()
            print(priority)
        }
    }
    
    var task: AssignedTask? {
        didSet {
            saveProcess = .edit
        }
    }
    private var saveProcess: SaveProcess = .add
    
    private var date = Date() {
        didSet {
            print("DATE: \(date)")
            updateDateLabels(for: date)
            setAccessToSaveButton()
        }
    }

    //MARK: - IBOutlets
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    @IBOutlet weak var taskURLTextField: UITextField!
    
    @IBOutlet weak var taskDateLabel: UILabel!
    @IBOutlet weak var taskTimeLabel: UILabel!
    
    @IBOutlet weak var dateForTaskSwitch: UISwitch!
    @IBOutlet weak var timeForTaskSwitch: UISwitch!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewsTargets()
        setupComponents()
        updateUI()
        setAccessToSaveButton()
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Ations
    
    @objc private func switchSetTaskDate(_ sender: UISwitch) {
        if dateForTaskSwitch.isOn {
            showDatePickerAlert(mode: .date, currentDate: date) { [weak self] date in
                guard let self = self else { return }
                guard let date = date else {
                    self.dateForTaskSwitch.isOn = false
                    self.taskDateLabel.textColor = .lightGray
                    return
                }
                if !self.timeForTaskSwitch.isOn {
                    self.date = self.dateManager.setDefaultTime(for: date)
                } else {
                    self.date = date
                }
            }
            taskDateLabel.textColor = .systemBlue
        } else {
            date = Date()
            taskDateLabel.textColor = .lightGray
        }
    }
    
    @objc private func switchSetTaskTime(_ sender: UISwitch) {
        if timeForTaskSwitch.isOn {
            showDatePickerAlert(mode: .time, currentDate: date) { [weak self] date in
                guard let self = self else { return }
                guard let date = date else {
                    self.timeForTaskSwitch.isOn = false
                    self.taskTimeLabel.textColor = .lightGray
                    return
                }
                self.date = date
            }
            taskTimeLabel.textColor = .systemBlue
        } else {
            self.date = self.dateManager.setDefaultTime(for: date)
            taskTimeLabel.text = Date().timeToString()
            taskTimeLabel.textColor = .lightGray
        }
    }
    
    //MARK: - IBAtions
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        let createdTask = createTask()
        print(createdTask)
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.saveTaskDelegate?.save(task: createdTask,
                                        process: self.saveProcess)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func textFieldsChanged(_ sender: UITextField) {
        setAccessToSaveButton()
    }
    
    //MARK: - Private methods
    
    private func setViewsTargets() {
        dateForTaskSwitch.addTarget(self, action: #selector(switchSetTaskDate(_:)), for: .valueChanged)
        timeForTaskSwitch.addTarget(self, action: #selector(switchSetTaskTime(_:)), for: .valueChanged)
    }
    
    private func setupComponents() {
        switch saveProcess {
        case .add:
            saveButton.title = "Добавить"
            self.title = "Новая задача"
        case .edit:
            saveButton.title = "Сохранить"
            self.title = task?.name
            guard let task = task else { return }
            priority = task.priority
            timeForTaskSwitch.isOn = task.isHaveActiveTime
            dateForTaskSwitch.isOn = task.isHaveActiveDate
            if let taskDate = task.date {
                date = taskDate
            }
        }
    }
    
    private func updateUI() {
        guard let task = task else {
            updateDateLabels(for: date)
            return
        }
        taskNameTextField.text = task.name
        taskDescriptionTextField.text = task.description
        taskURLTextField.text = task.url
        updateDateLabels(for: task.date ?? date)
        taskTimeLabel.textColor = timeForTaskSwitch.isOn ? .systemBlue : .lightGray
        taskDateLabel.textColor = dateForTaskSwitch.isOn ? .systemBlue : .lightGray
    }
    
    private func createTask() -> AssignedTask {
        let taskName = taskNameTextField.text ?? ""
        let taskDescription = taskDescriptionTextField.text
        let taskPriority = priority
        let taskURL = taskURLTextField.text
        let taskDate = (dateForTaskSwitch.isOn || timeForTaskSwitch.isOn) ? date : nil
        return AssignedTask(
            name: taskName,
            description: taskDescription,
            priority: taskPriority,
            date: taskDate,
            url: taskURL,
            isHaveActiveDate: dateForTaskSwitch.isOn,
            isHaveActiveTime: timeForTaskSwitch.isOn
        )
    }
    
    private func updateDateLabels(for date: Date) {
        taskDateLabel.text = date.dateToString()
        taskTimeLabel.text = date.timeToString()
    }
    
    private func setAccessToSaveButton() {
        switch saveProcess {
        case .add:
            saveButton.isEnabled = !(taskNameTextField.text ?? "").isEmpty
        case .edit:
            guard let currentTask = task else { return }
            let creatingTask = createTask()
            if (taskNameTextField.text ?? "").isEmpty || (creatingTask == currentTask) {
                saveButton.isEnabled = false
            } else {
                saveButton.isEnabled = true
            }
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let taskPriorityVC = segue.destination as? TaskPriorityViewController else { return }
        taskPriorityVC.taskPrioriy = priority
        taskPriorityVC.changePriorityDelegate = self
    }
}

//MARK: - TaskInfoViewControllerDelegate

extension TaskInfoViewController: TaskInfoViewControllerDelegate {
    func changePriority(to priority: AssignedTaskPriority) {
        self.priority = priority
    }
}
