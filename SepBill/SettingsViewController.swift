//
//  SettingsViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 14.10.24.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var tableNumbers: [Int] = []
    var tablePersonsCount: [Int: Int] = [:] // Словарь для хранения количества клиентов за каждым столом

    weak var delegate: SettingsViewControllerDelegate?

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var personsCountField: UITextField!
    @IBOutlet weak var tableNumberField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Загружаем номера столов
        if let savedData = UserDefaults.standard.data(forKey: "tableNumbers"),
           let savedNumbers = try? JSONDecoder().decode([Int].self, from: savedData) {
            tableNumbers = savedNumbers
        }

        // Загружаем количество клиентов за столами
        if let savedPersonsCountData = UserDefaults.standard.data(forKey: "tablePersonsCount"),
           let savedPersonsCount = try? JSONDecoder().decode([Int: Int].self, from: savedPersonsCountData) {
            tablePersonsCount = savedPersonsCount
        }

        confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)

        addToolBarToKeyboard(personsCountField)
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
        if let text = personsCountField.text, let count = Int(text) {
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
        guard let tableNumberText = tableNumberField.text,
              let tableNumber = Int(tableNumberText),
              let personsCountText = personsCountField.text,
              let personsCount = Int(personsCountText) else { return }

        // Добавляем новый номер стола
        tableNumbers.append(tableNumber)
        // Обновляем количество клиентов в словаре
        tablePersonsCount[tableNumber] = personsCount

        // Сохраняем данные
        if let savedData = try? JSONEncoder().encode(tableNumbers) {
            UserDefaults.standard.set(savedData, forKey: "tableNumbers")
        }

        // Сохраняем количество клиентов в UserDefaults
        if let savedPersonsCountData = try? JSONEncoder().encode(tablePersonsCount) {
            UserDefaults.standard.set(savedPersonsCountData, forKey: "tablePersonsCount")
        }

        // Уведомляем MainViewController о добавлении стола и количества клиентов
        delegate?.didUpdateTableNumbers(tableNumbers)
        delegate?.didUpdatePersonsCount(personsCount, forTable: tableNumber) // Передаем номер стола

        personsCountField.text = ""
        tableNumberField.text = ""
        confirmButton.isEnabled = false
    }
}
