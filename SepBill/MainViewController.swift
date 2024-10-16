//
//  MainViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 14.10.24.
//

import UIKit

// Протокол для делегата, отвечающего за обновление цены
protocol MainViewControllerDelegate: AnyObject {
    func didUpdateTotalPrice(_ price: Double)
}

protocol SettingsViewControllerDelegate: AnyObject {
    func didUpdateTableNumbers(_ tableNumbers: [Int])
    func didUpdatePersonsCount(_ personsCount: Int, forTable tableNumber: Int)
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MainViewControllerDelegate, MenuViewControllerDelegate, SettingsViewControllerDelegate {

    @IBOutlet weak var tables: UITableView!

    var totalPriceFromMenu: Double = 0
    var tableNumbers: [Int] = []
    var tablePersonsCount: [Int: Int] = [:] // Для хранения количества людей за каждым столом

    // MARK: - MainViewControllerDelegate
    func didUpdateTotalPrice(_ price: Double) {
        totalPriceFromMenu += price
        tables.reloadData() // Обновляем таблицу после изменения цены
    }

    // MARK: - SettingsViewControllerDelegate
    func didUpdateTableNumbers(_ tableNumbers: [Int]) {
        self.tableNumbers = tableNumbers
        
        // Загрузка количества клиентов из UserDefaults
        if let savedPersonsCountData = UserDefaults.standard.data(forKey: "tablePersonsCount"),
           let savedPersonsCount = try? JSONDecoder().decode([Int: Int].self, from: savedPersonsCountData) {
            self.tablePersonsCount = savedPersonsCount
        }
        
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
        debugPrint("На основном экране")
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableNumbers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableEditTableViewCell

        let tableNumber = tableNumbers[indexPath.row]
        let personsCount = tablePersonsCount[tableNumber] ?? 0 // Теперь возвращаем 0, если количество клиентов не установлено

        cell.tableNumberLabel.text = "Стол: \(tableNumber)"
        cell.clientBillLabel.text = "Счет: \(totalPriceFromMenu)р."

        cell.didUpdatePersonsCount(personsCount) // Обновляем количество людей за столом
        cell.didUpdateTotalPrice(totalPriceFromMenu) // Обновляем цену

        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsVC", let settingsVC = segue.destination as? SettingsViewController {
            settingsVC.delegate = self // Устанавливаем делегат для обновления настроек
        }
    }
}
