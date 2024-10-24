//
//  MainViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 14.10.24.
//

import UIKit

// Протокол для делегата, отвечающего за обновление счета первого клиента
protocol MainViewControllerDelegate: AnyObject {
    func updateBill(for tableNumber: Int, with client1Bill: Double)
    func updateSecondClientBill(for tableNumber: Int, with client2Bill: Double)
    func updateThirdClientBill(for tableNumber: Int, with client3Bill: Double)
    func updateFourthClientBill(for tableNumber: Int, with client4Bill: Double)
}

protocol SettingsViewControllerDelegate: AnyObject {
    func didUpdateTableNumbers(_ tableNumbers: [Int])
    func didUpdatePersonsCount(_ personsCount: Int, forTable tableNumber: Int)
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MainViewControllerDelegate, SettingsViewControllerDelegate, MenuViewControllerDelegate, MenuForSecondClientViewControllerDelegate, MenuForThirdClientViewControllerDelegate, MenuForFourthClientViewControllerDelegate {
    
    @IBOutlet weak var tables: UITableView!
    
    var client1BillFromMenu: [Int: Double] = [:] // Храним общий счет для первого клиента
    var client2BillFromMenu: [Int: Double] = [:]
    var client3BillFromMenu: [Int: Double] = [:]
    var client4BillFromMenu: [Int: Double] = [:]
    var totalPrices: [Int: Double] = [:]
    var tableNumbers: [Int] = []
    var tablePersonsCount: [Int: Int] = [:] // Для хранения количества людей за каждым столом
    var tableIndexMap: [Int: Int] = [:] // Для хранения индексов ячеек для столов
    var selectedTableIndex: Int = 0 // Хранит индекс выбранного стола
    
    // MARK: - SettingsViewControllerDelegate
    func didUpdateTableNumbers(_ tableNumbers: [Int]) {
        self.tableNumbers = tableNumbers
        loadBills()
        tables.reloadData() // Обновляем таблицу после изменения списка столов
    }
    
    func didUpdatePersonsCount(_ personsCount: Int, forTable tableNumber: Int) {
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
    
    @IBAction func showMenu2(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tables)
        if let indexPath = tables.indexPathForRow(at: buttonPosition) {
            selectedTableIndex = indexPath.row
            performSegue(withIdentifier: "showMenu2", sender: self)
        }
    }
    
    @IBAction func showMenu3(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tables)
        if let indexPath = tables.indexPathForRow(at: buttonPosition) {
            selectedTableIndex = indexPath.row
            performSegue(withIdentifier: "showMenu3", sender: self)
        }
    }
    
    @IBAction func showMenu4(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tables)
        if let indexPath = tables.indexPathForRow(at: buttonPosition) {
            selectedTableIndex = indexPath.row
            performSegue(withIdentifier: "showMenu4", sender: self)
        }
    }
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tables.dataSource = self
        tables.delegate = self
        
        if let savedData = UserDefaults.standard.data(forKey: "tableNumbers"),
           let savedNumbers = try? JSONDecoder().decode([Int].self, from: savedData) {
            tableNumbers = savedNumbers
        }

        if let savedPersonsCountData = UserDefaults.standard.data(forKey: "tablePersonsCount"),
           let savedPersonsCount = try? JSONDecoder().decode([Int: Int].self, from: savedPersonsCountData) {
            tablePersonsCount = savedPersonsCount
        }
        
        // Загрузка счетов для каждого стола
        loadBills()

        // Обновляем таблицу с общими счетами
        tables.reloadData()
    }
    
    func loadBills() {
        for tableNumber in tableNumbers {
            let keyPrefix = "clientBill\(tableNumber)"
            
            client1BillFromMenu[tableNumber] = UserDefaults.standard.double(forKey: "\(keyPrefix)Client1")
            client2BillFromMenu[tableNumber] = UserDefaults.standard.double(forKey: "\(keyPrefix)Client2")
            client3BillFromMenu[tableNumber] = UserDefaults.standard.double(forKey: "\(keyPrefix)Client3")
            client4BillFromMenu[tableNumber] = UserDefaults.standard.double(forKey: "\(keyPrefix)Client4")
            
            // Вычисляем общий счёт за стол
            let totalBill = (client1BillFromMenu[tableNumber] ?? 0.00) +
                            (client2BillFromMenu[tableNumber] ?? 0.00) +
                            (client3BillFromMenu[tableNumber] ?? 0.00) +
                            (client4BillFromMenu[tableNumber] ?? 0.00)
            
            totalPrices[tableNumber] = totalBill
            UserDefaults.standard.set(totalBill, forKey: "\(keyPrefix)TotalBill")
        }
    }
    
    func saveBillToUserDefaults(for tableNumber: Int) {
        let keyPrefix = "clientBill\(tableNumber)"
        
        // Сохраняем счет каждого клиента
        UserDefaults.standard.set(client1BillFromMenu[tableNumber], forKey: "\(keyPrefix)Client1")
        UserDefaults.standard.set(client2BillFromMenu[tableNumber], forKey: "\(keyPrefix)Client2")
        UserDefaults.standard.set(client3BillFromMenu[tableNumber], forKey: "\(keyPrefix)Client3")
        UserDefaults.standard.set(client4BillFromMenu[tableNumber], forKey: "\(keyPrefix)Client4")
        
        // Сохраняем общий счет
        let totalBill = (client1BillFromMenu[tableNumber] ?? 0.00) +
                        (client2BillFromMenu[tableNumber] ?? 0.00) +
                        (client3BillFromMenu[tableNumber] ?? 0.00) +
                        (client4BillFromMenu[tableNumber] ?? 0.00)
        UserDefaults.standard.set(totalBill, forKey: "\(keyPrefix)TotalBill")
    }
    
    func removeDataForTable(_ tableNumber: Int) {
        let keyPrefix = "clientBill\(tableNumber)"
        
        // Удаляем счета для клиентов
        UserDefaults.standard.removeObject(forKey: "\(keyPrefix)Client1")
        UserDefaults.standard.removeObject(forKey: "\(keyPrefix)Client2")
        UserDefaults.standard.removeObject(forKey: "\(keyPrefix)Client3")
        UserDefaults.standard.removeObject(forKey: "\(keyPrefix)Client4")
        
        UserDefaults.standard.removeObject(forKey: "productQuantitiesForTable_\(tableNumber)_client1")
        UserDefaults.standard.removeObject(forKey: "productQuantitiesForTable_\(tableNumber)_client2")
        UserDefaults.standard.removeObject(forKey: "productQuantitiesForTable_\(tableNumber)_client3")
        UserDefaults.standard.removeObject(forKey: "productQuantitiesForTable_\(tableNumber)_client4")
        
        // Удаляем общий счет
        UserDefaults.standard.removeObject(forKey: "\(keyPrefix)TotalBill")
        
        // Удаляем количество людей за столом
        if var tablePersonsCount = try? JSONDecoder().decode([Int: Int].self, from: UserDefaults.standard.data(forKey: "tablePersonsCount") ?? Data()) {
            tablePersonsCount.removeValue(forKey: tableNumber)
            let encodedPersonsCount = try? JSONEncoder().encode(tablePersonsCount)
            UserDefaults.standard.set(encodedPersonsCount, forKey: "tablePersonsCount")
        }
        
        // Удаляем стол из списка номеров столов
        if var tableNumbers = try? JSONDecoder().decode([Int].self, from: UserDefaults.standard.data(forKey: "tableNumbers") ?? Data()) {
            tableNumbers.removeAll { $0 == tableNumber }
            let encodedNumbers = try? JSONEncoder().encode(tableNumbers)
            UserDefaults.standard.set(encodedNumbers, forKey: "tableNumbers")
        }

        // Удаляем выбранные продукты для стола
        UserDefaults.standard.removeObject(forKey: "selectedProductsForTable_\(tableNumber)")
        UserDefaults.standard.removeObject(forKey: "selectedProductsForSecondClient_\(tableNumber)")
        UserDefaults.standard.removeObject(forKey: "selectedProductsForThirdClient_\(tableNumber)")
        UserDefaults.standard.removeObject(forKey: "selectedProductsForFourthClient_\(tableNumber)")
    }
    
    @IBAction func backToMain(_ segue: UIStoryboardSegue) {
        if let menuVC = segue.source as? MenuViewController {
            let selectedTable = tableNumbers[selectedTableIndex]
            let currentBill = client1BillFromMenu[selectedTable] ?? 0.00
            let newBill = menuVC.client1Bill
            updateBill(for: selectedTable, with: currentBill + newBill)
        } else if let menu2VC = segue.source as? MenuForSecondClientViewController {
            let selectedTable = tableNumbers[selectedTableIndex]
            let currentBill = client2BillFromMenu[selectedTable] ?? 0.00
            let newBill = menu2VC.client2Bill
            updateSecondClientBill(for: selectedTable, with: currentBill + newBill)
        } else if let menu3VC = segue.source as? MenuForThirdClientViewController {
            let selectedTable = tableNumbers[selectedTableIndex]
            let currentBill = client3BillFromMenu[selectedTable] ?? 0.00
            let newBill = menu3VC.client3Bill
            updateThirdClientBill(for: selectedTable, with: currentBill + newBill)
        } else if let menu4VC = segue.source as? MenuForFourthClientViewController {
            let selectedTable = tableNumbers[selectedTableIndex]
            let currentBill = client4BillFromMenu[selectedTable] ?? 0.00
            let newBill = menu4VC.client4Bill
            updateFourthClientBill(for: selectedTable, with: currentBill + newBill)
        }
        
        debugPrint("На основном экране")
    }
    
    @IBAction func cancelToMain(_ segue: UIStoryboardSegue) {
        debugPrint("Отмена, вернулся на основной экран")
    }
    
    @IBAction func billMade(_ segue: UIStoryboardSegue) {
        
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableNumbers.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Кастомное действие "Удалить стол"
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, completionHandler) in
            self.deleteTable(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash")
        
        let billAction = UIContextualAction(style: .normal, title: "Чек") { (action, view, completionHandler) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "billVC", sender: indexPath)
            }
            completionHandler(true)
        }
        
        billAction.backgroundColor = .systemMint
        billAction.image = UIImage(systemName: "wallet.pass")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, billAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableEditTableViewCell
        
        let tableNumber = tableNumbers[indexPath.row]
        let personsCount = tablePersonsCount[tableNumber] ?? 0
        let client1Bill = client1BillFromMenu[tableNumber] ?? 0.00
        let client2Bill = client2BillFromMenu[tableNumber] ?? 0.00
        let client3Bill = client3BillFromMenu[tableNumber] ?? 0.00
        let client4Bill = client4BillFromMenu[tableNumber] ?? 0.00
                
        tableIndexMap[tableNumber] = indexPath.row
        
        cell.tableNumberLabel.text = "Стол: \(tableNumber)"
        cell.priceLabel1.text = "\(client1Bill) р."
        cell.priceLabel2.text = "\(client2Bill) р."
        cell.priceLabel3.text = "\(client3Bill) р."
        cell.priceLabel4.text = "\(client4Bill) р."
        cell.tableBillLabel.text = "\(totalPrices[tableNumber] ?? 0.00) р."
        cell.didUpdatePersonsCount(personsCount)

        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 177
    }
    
    // MARK: - MainViewControllerDelegate
    func updateBill(for tableNumber: Int, with client1Bill: Double) {
        if let rowIndex = tableIndexMap[tableNumber] {
            let indexPath = IndexPath(row: rowIndex, section: 0)
            if let cell = tables.cellForRow(at: indexPath) as? TableEditTableViewCell {
                client1BillFromMenu[tableNumber] = client1Bill
                let totalBill = (client1BillFromMenu[tableNumber] ?? 0.00) + (client2BillFromMenu[tableNumber] ?? 0.00) + (client3BillFromMenu[tableNumber] ?? 0.00) + (client4BillFromMenu[tableNumber] ?? 0.00)
                cell.priceLabel1.text = "\(client1Bill) р."
                cell.tableBillLabel.text = "\(totalBill) р."
                saveBillToUserDefaults(for: tableNumber)
            }
        }
    }

    
    // MARK: - MenuForSecondClientViewControllerDelegate
    func updateSecondClientBill(for tableNumber: Int, with client2Bill: Double) {
        if let rowIndex = tableIndexMap[tableNumber] {
            let indexPath = IndexPath(row: rowIndex, section: 0)
            if let cell = tables.cellForRow(at: indexPath) as? TableEditTableViewCell {
                client2BillFromMenu[tableNumber] = client2Bill
                let totalBill = (client1BillFromMenu[tableNumber] ?? 0.00) + (client2BillFromMenu[tableNumber] ?? 0.00) + (client3BillFromMenu[tableNumber] ?? 0.00) + (client4BillFromMenu[tableNumber] ?? 0.00)
                cell.priceLabel2.text = "\(client2Bill) р."
                cell.tableBillLabel.text = "\(totalBill) р."
                saveBillToUserDefaults(for: tableNumber)
            }
        }
    }
    
    func updateThirdClientBill(for tableNumber: Int, with client3Bill: Double) {
        if let rowIndex = tableIndexMap[tableNumber] {
            let indexPath = IndexPath(row: rowIndex, section: 0)
            if let cell = tables.cellForRow(at: indexPath) as? TableEditTableViewCell {
                client3BillFromMenu[tableNumber] = client3Bill
                let totalBill = (client1BillFromMenu[tableNumber] ?? 0.00) + (client2BillFromMenu[tableNumber] ?? 0.00) + (client3BillFromMenu[tableNumber] ?? 0.00) + (client4BillFromMenu[tableNumber] ?? 0.00)
                cell.priceLabel3.text = "\(client3Bill) р."
                cell.tableBillLabel.text = "\(totalBill) р."
                saveBillToUserDefaults(for: tableNumber)
            }
        }
    }
    
    func updateFourthClientBill(for tableNumber: Int, with client4Bill: Double) {
        if let rowIndex = tableIndexMap[tableNumber] {
            let indexPath = IndexPath(row: rowIndex, section: 0)
            if let cell = tables.cellForRow(at: indexPath) as? TableEditTableViewCell {
                client4BillFromMenu[tableNumber] = client4Bill
                let totalBill = (client1BillFromMenu[tableNumber] ?? 0.00) + (client2BillFromMenu[tableNumber] ?? 0.00) + (client3BillFromMenu[tableNumber] ?? 0.00) + (client4BillFromMenu[tableNumber] ?? 0.00)
                cell.priceLabel4.text = "\(client4Bill) р."
                cell.tableBillLabel.text = "\(totalBill) р."
                saveBillToUserDefaults(for: tableNumber)
            }
        }
    }
    
    func deleteTable(at index: Int) {
        let tableNumber = tableNumbers[index]
        
        // Удаляем данные для этого стола
        removeDataForTable(tableNumber)
        
        // Удаляем данные из локальных массивов
        client1BillFromMenu.removeValue(forKey: tableNumber)
        client2BillFromMenu.removeValue(forKey: tableNumber)
        client3BillFromMenu.removeValue(forKey: tableNumber)
        client4BillFromMenu.removeValue(forKey: tableNumber)
        totalPrices.removeValue(forKey: tableNumber)
        
        // Удаляем стол из списка столов
        tableNumbers.remove(at: index)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsVC", let settingsVC = segue.destination as? SettingsViewController {
            settingsVC.delegate = self
        }
        if segue.identifier == "showMenu1", let menu1VC = segue.destination as? MenuViewController {
            menu1VC.delegate = self
            menu1VC.tables = tableNumbers
            menu1VC.selectedTableIndex = selectedTableIndex
        }
        if segue.identifier == "showMenu2", let menu2VC = segue.destination as? MenuForSecondClientViewController {
            menu2VC.delegate = self
            menu2VC.tables = tableNumbers
            menu2VC.selectedTableIndex = selectedTableIndex
        }
        if segue.identifier == "showMenu3", let menu3VC = segue.destination as? MenuForThirdClientViewController {
            menu3VC.delegate = self
            menu3VC.tables = tableNumbers
            menu3VC.selectedTableIndex = selectedTableIndex
        }
        if segue.identifier == "showMenu4", let menu4VC = segue.destination as? MenuForFourthClientViewController {
            menu4VC.delegate = self
            menu4VC.tables = tableNumbers
            menu4VC.selectedTableIndex = selectedTableIndex
        }
        if segue.identifier == "billVC", let billVC = segue.destination as? BillViewController {
            if let indexPath = sender as? IndexPath {
                billVC.tableIndex = indexPath
                billVC.selectedTableIndex = indexPath.row
                billVC.tables = tableNumbers
                billVC.mainVC = self
            }
        }
    }
}
