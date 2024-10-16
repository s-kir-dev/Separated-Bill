//
//  MainViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 14.10.24.
//

import UIKit

// Протокол для делегата, отвечающего за обновление цены
protocol MainViewControllerDelegate: AnyObject {
    func updateBill(for tableNumber: Int, with client1Bill: Double)
}

protocol SettingsViewControllerDelegate: AnyObject {
    func didUpdateTableNumbers(_ tableNumbers: [Int])
    func didUpdatePersonsCount(_ personsCount: Int, forTable tableNumber: Int)
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MainViewControllerDelegate, SettingsViewControllerDelegate, MenuViewControllerDelegate {

    @IBOutlet weak var tables: UITableView!

    var client1BillFromMenu: [Int: Double] = [:] // Храним общий счет для каждого стола
    var tableNumbers: [Int] = []
    var tablePersonsCount: [Int: Int] = [:] // Для хранения количества людей за каждым столом
    var tableIndexMap: [Int: Int] = [:] // Для хранения индексов ячеек для столов
    var selectedTableIndex: Int = 0 // Хранит индекс выбранного стола

    // MARK: - SettingsViewControllerDelegate
    func didUpdateTableNumbers(_ tableNumbers: [Int]) {
        self.tableNumbers = tableNumbers
        tables.reloadData() // Обновляем таблицу после изменения списка столов
    }

    func didUpdatePersonsCount(_ personsCount: Int, forTable tableNumber: Int) {
        // Обновляем количество клиентов для указанного стола
        tablePersonsCount[tableNumber] = personsCount
        tables.reloadData() // Перезагружаем таблицу, если изменилось количество клиентов
    }

    @IBAction func plusButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "settingsVC", sender: self)
        debugPrint("Перешел на экран добавления стола")
    }

    @IBAction func showMenu(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tables) // Получаем позицию кнопки в таблице
        if let indexPath = tables.indexPathForRow(at: buttonPosition) {
            selectedTableIndex = indexPath.row // Получаем индекс выбранного стола
            performSegue(withIdentifier: "showMenu1", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tables.dataSource = self
        tables.delegate = self

        // Загрузка номеров столов и количества клиентов из UserDefaults
        if let savedData = UserDefaults.standard.data(forKey: "tableNumbers"),
           let savedNumbers = try? JSONDecoder().decode([Int].self, from: savedData) {
            tableNumbers = savedNumbers
        }

        // Загрузка количества клиентов
        if let savedPersonsCountData = UserDefaults.standard.data(forKey: "tablePersonsCount"),
           let savedPersonsCount = try? JSONDecoder().decode([Int: Int].self, from: savedPersonsCountData) {
            tablePersonsCount = savedPersonsCount
        }
    }

    @IBAction func backToMain(_ segue: UIStoryboardSegue) {
        if let menuVC = segue.source as? MenuViewController {
            let selectedTable = tableNumbers[selectedTableIndex]
            // Передаем обновленный счет клиента из MenuVC
            updateBill(for: selectedTable, with: menuVC.client1Bill)
        }
        debugPrint("На основном экране")
    }
    
    @IBAction func cancelToMain(_ segue: UIStoryboardSegue) {
        debugPrint("Отмена, вернулся на основной экран")
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableNumbers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableEditTableViewCell

        let tableNumber = tableNumbers[indexPath.row]
        let personsCount = tablePersonsCount[tableNumber] ?? 0
        let client1Bill = client1BillFromMenu[tableNumber] ?? 0.0

        // Сохраняем индекс ячейки для стола
        tableIndexMap[tableNumber] = indexPath.row

        cell.tableNumberLabel.text = "Стол: \(tableNumber)"
        cell.priceLabel1.text = "\(client1Bill) р."
        cell.didUpdatePersonsCount(personsCount)
        cell.didUpdateTotalPrice(client1Bill)

        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    // MARK: - MainViewControllerDelegate
    func updateBill(for tableNumber: Int, with client1Bill: Double) {
        if let rowIndex = tableIndexMap[tableNumber] {
            let indexPath = IndexPath(row: rowIndex, section: 0)
            if let cell = tables.cellForRow(at: indexPath) as? TableEditTableViewCell {
                // Получаем текущее значение счета из UserDefaults
                let key = "клиент1Стол\(tableNumber)" // Создаем ключ для сохранения
                let existingBill = UserDefaults.standard.double(forKey: key) // Получаем существующее значение

                // Обновляем общий счет для стола
                let newTotalBill = existingBill + client1Bill // Прибавляем новое значение
                client1BillFromMenu[tableNumber] = newTotalBill // Обновляем локальную переменную
                cell.priceLabel1.text = "\(newTotalBill) р."
                cell.tableBillLabel.text = "\(newTotalBill) р."

                // Сохраняем обновленный счет клиента в UserDefaults
                UserDefaults.standard.set(newTotalBill, forKey: key)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsVC", let settingsVC = segue.destination as? SettingsViewController {
            settingsVC.delegate = self // Устанавливаем делегат для обновления настроек
        }
        if segue.identifier == "showMenu1", let menu1VC = segue.destination as? MenuViewController {
            menu1VC.delegate = self
            menu1VC.tables = tableNumbers
            menu1VC.selectedTableIndex = selectedTableIndex // Передаем индекс выбранного стола
        }
    }
}
