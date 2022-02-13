//
//  Extension + TaskViewController.swift
//  TaskManager
//
//  Created by Малиль Дугулюбгов on 10.02.2022.
//

import UIKit

extension TaskInfoViewController {
    
    func showDatePickerAlert(mode: UIDatePicker.Mode, currentDate: Date, completionHandler: @escaping(Date?) -> Void) {
        
        //Setup alert
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        alert.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        //Setup datePicker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = currentDate
        
        //Setup alert actions
        let doneAction = UIAlertAction(title: "Готово", style: .default) { _ in
            completionHandler(datePicker.date)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive) { _ in
            completionHandler(nil)
        }
        
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        
        //Date picker constraints
        alert.view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalTo: alert.view.widthAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 150),
            datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20)
        ])
        
        //Present alert
        present(alert, animated: true)
    }
}

//MARK: - UITextFieldDelegage

extension TaskInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
