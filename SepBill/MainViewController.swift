//
//  MainViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 14.10.24.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func updateBill(for tableNumber: Int, with client1Bill: Double)
    func updateSecondClientBill(for tableNumber: Int, with client2Bill: Double)
    func updateThirdClientBill(for tableNumber: Int, with client3Bill: Double)
    func updateFourthClientBill(for tableNumber: Int, with client4Bill: Double)
    func updateFifthClientBill(for tableNumber: Int, with client5Bill: Double)
    func updateSixthClientBill(for tableNumber: Int, with client6Bill: Double)
}

protocol SettingsViewControllerDelegate: AnyObject {
    func didUpdateTableNumbers(_ tableNumbers: [Int])
    func didUpdatePersonsCount(_ personsCount: Int, forTable tableNumber: Int)
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MainViewControllerDelegate, SettingsViewControllerDelegate, MenuViewControllerDelegate, MenuForSecondClientViewControllerDelegate, MenuForThirdClientViewControllerDelegate, MenuForFourthClientViewControllerDelegate, MenuForFifthClientViewControllerDelegate, MenuForSixthClientViewControllerDelegate {
    
    
    @IBOutlet weak var tables: UITableView!
    @IBOutlet weak var emptyImage: UIImageView!

    
    var client1BillFromMenu: [Int: Double] = [:] // Храним общий счет для первого клиента
    var client2BillFromMenu: [Int: Double] = [:]
    var client3BillFromMenu: [Int: Double] = [:]
    var client4BillFromMenu: [Int: Double] = [:]
    var client5BillFromMenu: [Int: Double] = [:]
    var client6BillFromMenu: [Int: Double] = [:]
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
        let buttonPosition = sender.convert(CGPoint.zero, to: tables)
        if let indexPath = tables.indexPathForRow(at: buttonPosition) {
            selectedTableIndex = indexPath.row
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
    
    @IBAction func showMenu5(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tables)
        if let indexPath = tables.indexPathForRow(at: buttonPosition) {
            selectedTableIndex = indexPath.row
            performSegue(withIdentifier: "showMenu5", sender: self)
        }
    }
    
    @IBAction func showMenu6(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: tables)
        if let indexPath = tables.indexPathForRow(at: buttonPosition) {
            selectedTableIndex = indexPath.row
            performSegue(withIdentifier: "showMenu6", sender: self)
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
            client5BillFromMenu[tableNumber] = UserDefaults.standard.double(forKey: "\(keyPrefix)Client5")
            client6BillFromMenu[tableNumber] = UserDefaults.standard.double(forKey: "\(keyPrefix)Client6")
            
            // Вычисляем общий счёт за стол
            let totalBill = updateTotalBill(for: tableNumber)
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
        UserDefaults.standard.set(client5BillFromMenu[tableNumber], forKey: "\(keyPrefix)Client5")
        UserDefaults.standard.set(client6BillFromMenu[tableNumber], forKey: "\(keyPrefix)Client6")
        
        // Сохраняем общий счет
        let totalBill = updateTotalBill(for: tableNumber)
        UserDefaults.standard.set(totalBill, forKey: "\(keyPrefix)TotalBill")
    }
    
    func removeDataForTable(_ tableNumber: Int) {
        let keyPrefix = "clientBill\(tableNumber)"
        
        // Удаляем счета для клиентов
        UserDefaults.standard.removeObject(forKey: "\(keyPrefix)Client1")
        UserDefaults.standard.removeObject(forKey: "\(keyPrefix)Client2")
        UserDefaults.standard.removeObject(forKey: "\(keyPrefix)Client3")
        UserDefaults.standard.removeObject(forKey: "\(keyPrefix)Client4")
        UserDefaults.standard.removeObject(forKey: "\(keyPrefix)Client5")
        UserDefaults.standard.removeObject(forKey: "\(keyPrefix)Client6")

        UserDefaults.standard.removeObject(forKey: "productQuantitiesForTable_\(tableNumber)_client1")
        UserDefaults.standard.removeObject(forKey: "productQuantitiesForTable_\(tableNumber)_client2")
        UserDefaults.standard.removeObject(forKey: "productQuantitiesForTable_\(tableNumber)_client3")
        UserDefaults.standard.removeObject(forKey: "productQuantitiesForTable_\(tableNumber)_client4")
        UserDefaults.standard.removeObject(forKey: "productQuantitiesForTable_\(tableNumber)_client5")
        UserDefaults.standard.removeObject(forKey: "productQuantitiesForTable_\(tableNumber)_client6")

        
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
        UserDefaults.standard.removeObject(forKey: "selectedProductsForFifthClient_\(tableNumber)")
        UserDefaults.standard.removeObject(forKey: "selectedProductsForSixthClient_\(tableNumber)")

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
        } else if let menu5VC = segue.source as? MenuForFifthViewController {
            let selectedTable = tableNumbers[selectedTableIndex]
            let currentBill = client5BillFromMenu[selectedTable] ?? 0.00
            let newBill = menu5VC.client5Bill
            updateFifthClientBill(for: selectedTable, with: currentBill + newBill)
        } else if let menu6VC = segue.source as? MenuForSixthViewController {
            let selectedTable = tableNumbers[selectedTableIndex]
            let currentBill = client6BillFromMenu[selectedTable] ?? 0.00
            let newBill = menu6VC.client6Bill
            updateSixthClientBill(for: selectedTable, with: currentBill + newBill)
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
        if tableNumbers.count == 0 {
            emptyImage.isHidden = false
        } else {
            emptyImage.isHidden = true
        }
        return tableNumbers.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Кастомное действие "Удалить стол"
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, completionHandler) in
            self.deleteTable(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red.withAlphaComponent(0.9)
        deleteAction.image = UIImage(systemName: "trash")
        
        let updatePeopleCountAction = UIContextualAction(style: .normal, title: "Изменить") { (action, view, completionHandler) in
            let tableNumber = self.tableNumbers[indexPath.row]
            
            let alert = UIAlertController(title: "Изменить количество людей", message: "Введите новое количество людей за столом", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Количество людей"
                textField.keyboardType = .numberPad
            }
            
            let saveAction = UIAlertAction(title: "Сохранить", style: .default) { (_) in
                if let countText = alert.textFields?.first?.text, let count = Int(countText) {
                        if count >= 1 && count <= 6 {
                            self.didUpdatePersonsCount(count, forTable: tableNumber)
                            
                            self.tablePersonsCount[tableNumber] = count
                            
                            if let savedPersonsCountData = try? JSONEncoder().encode(self.tablePersonsCount) {
                                UserDefaults.standard.set(savedPersonsCountData, forKey: "tablePersonsCount")
                            }
                        } else {
                            let errorAlert = UIAlertController(title: "Ошибка", message: "Количество людей должно быть от 1 до 6.", preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            completionHandler(true)
        }

        updatePeopleCountAction.backgroundColor = .purple.withAlphaComponent(0.5)
        updatePeopleCountAction.image = UIImage(systemName: "square.and.pencil")
            

        let billAction = UIContextualAction(style: .normal, title: "Чек") { (action, view, completionHandler) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "billVC", sender: indexPath)
            }
            completionHandler(true)
        }
        
        billAction.backgroundColor = .systemMint.withAlphaComponent(0.95)
        billAction.image = UIImage(systemName: "wallet.pass")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, updatePeopleCountAction, billAction])
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
        let client5Bill = client5BillFromMenu[tableNumber] ?? 0.00
        let client6Bill = client6BillFromMenu[tableNumber] ?? 0.00

                
        tableIndexMap[tableNumber] = indexPath.row
        
        cell.tableNumberLabel.text = "Стол: \(tableNumber)"
        cell.priceLabel1.text = "\(client1Bill) р."
        cell.priceLabel2.text = "\(client2Bill) р."
        cell.priceLabel3.text = "\(client3Bill) р."
        cell.priceLabel4.text = "\(client4Bill) р."
        cell.priceLabel5.text = "\(client5Bill) р."
        cell.priceLabel6.text = "\(client6Bill) р."

        cell.tableBillLabel.text = "\(totalPrices[tableNumber] ?? 0.00) р."
        cell.didUpdatePersonsCount(personsCount)

        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 264
    }
    
    // MARK: - MainViewControllerDelegate
    func updateBill(for tableNumber: Int, with client1Bill: Double) {
        if let rowIndex = tableIndexMap[tableNumber] {
            let indexPath = IndexPath(row: rowIndex, section: 0)
            if let cell = tables.cellForRow(at: indexPath) as? TableEditTableViewCell {
                client1BillFromMenu[tableNumber] = client1Bill
                let totalBill = updateTotalBill(for: tableNumber)
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
                let totalBill = updateTotalBill(for: tableNumber)
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
                let totalBill = updateTotalBill(for: tableNumber)
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
                let totalBill = updateTotalBill(for: tableNumber)
                cell.priceLabel4.text = "\(client4Bill) р."
                cell.tableBillLabel.text = "\(totalBill) р."
                saveBillToUserDefaults(for: tableNumber)
            }
        }
    }
    
    func updateFifthClientBill(for tableNumber: Int, with client5Bill: Double) {
        if let rowIndex = tableIndexMap[tableNumber] {
            let indexPath = IndexPath(row: rowIndex, section: 0)
            if let cell = tables.cellForRow(at: indexPath) as? TableEditTableViewCell {
                client5BillFromMenu[tableNumber] = client5Bill
                let totalBill = updateTotalBill(for: tableNumber)
                cell.priceLabel5.text = "\(client5Bill) р."
                cell.tableBillLabel.text = "\(totalBill) р."
                saveBillToUserDefaults(for: tableNumber)
            }
        }
    }
    
    func updateSixthClientBill(for tableNumber: Int, with client6Bill: Double) {
        if let rowIndex = tableIndexMap[tableNumber] {
            let indexPath = IndexPath(row: rowIndex, section: 0)
            if let cell = tables.cellForRow(at: indexPath) as? TableEditTableViewCell {
                client6BillFromMenu[tableNumber] = client6Bill
                let totalBill = updateTotalBill(for: tableNumber)
                cell.priceLabel6.text = "\(client6Bill) р."
                cell.tableBillLabel.text = "\(totalBill) р."
                saveBillToUserDefaults(for: tableNumber)
            }
        }
    }

    func updateTotalBill(for tableNumber: Int) -> Double {
        let bill1 = client1BillFromMenu[tableNumber] ?? 0.00
        let bill2 = client2BillFromMenu[tableNumber] ?? 0.00
        let bill3 = client3BillFromMenu[tableNumber] ?? 0.00
        let bill4 = client4BillFromMenu[tableNumber] ?? 0.00
        let bill5 = client5BillFromMenu[tableNumber] ?? 0.00
        let bill6 = client6BillFromMenu[tableNumber] ?? 0.00
        
        totalPrices[tableNumber] = bill1 + bill2 + bill3 + bill4 + bill5 + bill6
        return totalPrices[tableNumber] ?? 0.00
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
        client5BillFromMenu.removeValue(forKey: tableNumber)
        client6BillFromMenu.removeValue(forKey: tableNumber)
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
        if segue.identifier == "showMenu5", let menu5VC = segue.destination as? MenuForFifthViewController {
            menu5VC.delegate = self
            menu5VC.tables = tableNumbers
            menu5VC.selectedTableIndex = selectedTableIndex
        }
        if segue.identifier == "showMenu6", let menu6VC = segue.destination as? MenuForSixthViewController {
            menu6VC.delegate = self
            menu6VC.tables = tableNumbers
            menu6VC.selectedTableIndex = selectedTableIndex
        }
        if segue.identifier == "billVC", let billVC = segue.destination as? BillViewController {
            if let indexPath = sender as? IndexPath {
                billVC.tableIndex = indexPath
                billVC.selectedTableIndex = indexPath.row
                billVC.tables = tableNumbers
                if let personsCount = tablePersonsCount[tableNumbers[indexPath.row]] {
                    billVC.clientsCount = personsCount
                } else {
                    billVC.clientsCount = 0 
                }
                billVC.mainVC = self
            }
        }
    }
}
