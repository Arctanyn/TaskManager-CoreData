//
//  StorageManager.swift
//  TaskManager
//
//  Created by Малиль Дугулюбгов on 13.02.2022.
//

import UIKit
import CoreData

class StorageManager {
    
    //MARK: Properties
    
    static let shared = StorageManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Methods
    
    func save(_ task: AssignedTask) {
        guard
            let entityDescription = NSEntityDescription.entity(forEntityName: "MyTask", in: context),
            let myNewTask = NSManagedObject(entity: entityDescription, insertInto: context) as? MyTask
        else { return }
        changeData(of: myNewTask, from: task)
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func update(task: AssignedTask, at index: Int) {
        guard let tasks = fetchData() else { return }
        let myTask = tasks[index]
        changeData(of: myTask, from: task)
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    func fetchData() -> [MyTask]? {
        let fetchRequest: NSFetchRequest<MyTask> = MyTask.fetchRequest()
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func delete(at index: Int) {
        guard let tasks = fetchData() else { return }
        let task = tasks[index]
        context.delete(task)
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func deleteAll() {
        let fetchRequet = NSFetchRequest<NSFetchRequestResult>(entityName: "MyTask")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequet)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    //MARK: - Private methods
    
    private func changeData(of model: MyTask, from task: AssignedTask) {
        model.name = task.name
        model.taskDescription = task.description
        model.url = task.url
        model.date = task.date
        model.priority = task.priority.rawValue
        model.isHaveActiveTime = task.isHaveActiveTime
        model.isHaveActiveDate = task.isHaveActiveDate
    }
    
}
