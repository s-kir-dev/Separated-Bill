//
//  SettingsViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 14.10.24.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func didUpdateTableNumbers(_ tableNumbers: [Int])
}

class SettingsViewController: UIViewController {
    
    var tableNumbers: [Int] = []
    
    weak var delegate: SettingsViewControllerDelegate?
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var personsCount: UITextField!
    @IBOutlet weak var tableNumberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedData = UserDefaults.standard.data(forKey: "tableNumbers"),
           let savedNumbers = try? JSONDecoder().decode([Int].self, from: savedData) {
            tableNumbers = savedNumbers
        }
        
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)

        addToolBarToKeyboard(personsCount)
        addToolBarToKeyboard(tableNumberField)

    }
    
    func addToolBarToKeyboard(_ field: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        
        field.inputAccessoryView = toolbar
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
        validateInput()
    }

    func validateInput() {
        let isPersonsCountValid = validatePersonsCount()
        let isTableNumberValid = validateTableNumber()
        
        confirmButton.isEnabled = isPersonsCountValid && isTableNumberValid
    }

    func validatePersonsCount() -> Bool {
        var bool = false
        if let text = personsCount.text, let count = Int(text) {
            if count > 0 && count <= 4 {
                bool = true
            } else {
                let message = "Введите количество человек от 1 до 4"
                showAlert(title: "Перебор!", message: message)
                bool = false
            }
        }
        return bool
    }

    func validateTableNumber() -> Bool {
        var bool = false
        if let text = tableNumberField.text, let tableNumber = Int(text) {
            if tableNumbers.contains(tableNumber) {
                let message = "Номер стола \(tableNumber) уже есть."
                showAlert(title: "Ошибка!", message: message)
                bool = false
            } else {
                bool = true
            }
        }
        return bool
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    @objc func confirmButtonPressed() {
          if let text = tableNumberField.text, let tableNumber = Int(text) {
              tableNumbers.append(tableNumber)
              if let savedData = try? JSONEncoder().encode(tableNumbers) {
                  UserDefaults.standard.set(savedData, forKey: "tableNumbers")
              }
          }
        
        delegate?.didUpdateTableNumbers(tableNumbers)

          personsCount.text = ""
          tableNumberField.text = ""
          confirmButton.isEnabled = false
      }
}
