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
            let myTask = NSManagedObject(entity: entityDescription, insertInto: context) as? MyTask
        else { return }
        
        myTask.name = task.name
        myTask.taskDescription = task.description
        myTask.url = task.url
        myTask.date = task.date
        myTask.priority = task.priority.rawValue
        myTask.isHaveActiveTime = task.isHaveActiveTime
        myTask.isHaveActiveDate = task.isHaveActiveDate
        
        if context.hasChanges {
            saveContext()
        }
    }
    
    func update(task: AssignedTask, to newTask: AssignedTask) {
        findObjectInStorage(with: task) { [unowned self] myTask in
            myTask.setValuesForKeys(self.changeData(from: newTask))
        }
        if context.hasChanges {
            saveContext()
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
    
    func delete(task: AssignedTask) {
        findObjectInStorage(with: task) { [context] myTask in
            context.delete(myTask)
        }
        saveContext()
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
    
    private func changeData(from task: AssignedTask) -> [String: Any] {
        var parameters = [String: Any]()
        
        parameters["name"] = task.name
        parameters["taskDescription"] = task.description
        parameters["url"] = task.url
        parameters["date"] = task.date
        parameters["priority"] = task.priority.rawValue
        parameters["isHaveActiveTime"] = task.isHaveActiveTime
        parameters["isHaveActiveDate"] = task.isHaveActiveDate
        
        return parameters
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    private func checkForEquality(storedModel: MyTask, task: AssignedTask) -> Bool {
        guard
            storedModel.name == task.name,
            storedModel.priority == task.priority.rawValue,
            storedModel.taskDescription == task.description,
            storedModel.url == task.url,
            storedModel.date == task.date
        else { return false }
        return true
    }
    
    private func findObjectInStorage(with task: AssignedTask, completion: @escaping (MyTask) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyTask")
        fetchRequest.predicate = NSPredicate(format: "name = %@", task.name)
        
        do {
            guard let results = try context.fetch(fetchRequest) as? [NSManagedObject] else { return }
            if !results.isEmpty {
                guard let myTask = results.first as? MyTask,
                      checkForEquality(storedModel: myTask, task: task)
                else { return }
                completion(myTask)
            }
        } catch let error {
            print(error)
        }
    }
 }
