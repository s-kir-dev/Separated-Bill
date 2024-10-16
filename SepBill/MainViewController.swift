//
//  MainViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 14.10.24.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func didUpdateTotalPrice(_ price: Double)
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MainViewControllerDelegate, MenuViewControllerDelegate, SettingsViewControllerDelegate {
    
    func didUpdateTotalPrice(_ price: Double) {
        totalPriceFromMenu += price
    }
    
    
    @IBOutlet weak var tables: UITableView!
    
    var personCount: Int = 0
    var totalPriceFromMenu: Double = 0
    var tableNumbers: [Int] = []

    func didUpdateTableNumbers(_ tableNumbers: [Int]) {
        self.tableNumbers = tableNumbers
        tables.reloadData()
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "settingsVC", sender: self)
        debugPrint("Перешел на экран добавления стола")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backToMain(_ segue: UIStoryboardSegue) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableEditTableViewCell
        cell.clientBillLabel.text = "Счет: \(totalPriceFromMenu)р."
        cell.tableNumber.text = "Стол №\(tableNumbers[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsVC", let settingsVC = segue.destination as? SettingsViewController {
            settingsVC.delegate = self
        }
    }
}
