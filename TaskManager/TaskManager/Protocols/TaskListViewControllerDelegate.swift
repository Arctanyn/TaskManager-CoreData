//
//  TaskListViewControllerDelegate.swift
//  TaskManager
//
//  Created by Малиль Дугулюбгов on 10.02.2022.
//

import UIKit

protocol TaskListViewControllerDelegate: AnyObject {
    func save(task: AssignedTask, process: SaveProcess) -> Void
    func deleteCell(at locaton: CGPoint) -> Void
}
