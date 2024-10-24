//
//  BillViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 23.10.24.
//

import UIKit

class BillViewController: UIViewController {

    @IBOutlet weak var tableNumberLabel: UILabel!
    @IBOutlet weak var client1Bill: UILabel!
    @IBOutlet weak var client2Bill: UILabel!
    @IBOutlet weak var client3Bill: UILabel!
    @IBOutlet weak var client4Bill: UILabel!
    @IBOutlet weak var tableBill: UILabel!
    
    var tableIndex: IndexPath!
    
    var selectedTableIndex: Int = 0
    var tables = [Int]()
    var menuProducts: [Product] = []
    var allSelectedProducts: [Product] = []
    var firstProducts: Int = 0
    var secondProducts: Int = 0
    var thirdProducts: Int = 0
    var fourthProducts: Int = 0
    
    var mainVC: MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuProducts.append(contentsOf: Products.drinksWithoutAlcohol)
        menuProducts.append(contentsOf: Products.drinksWithAlcohol)
        menuProducts.append(contentsOf: Products.hotFishDishes)
        menuProducts.append(contentsOf: Products.hotMeatDishes)
        menuProducts.append(contentsOf: Products.pasta)
        menuProducts.append(contentsOf: Products.soups)
        menuProducts.append(contentsOf: Products.salats)
        menuProducts.append(contentsOf: Products.snacks)
        menuProducts.append(contentsOf: Products.desserts)

        if let savedProductNames = UserDefaults.standard.array(forKey: "selectedProductsForTable_\(tables[selectedTableIndex])") as? [String] {
            let selectedProducts = menuProducts.filter { savedProductNames.contains($0.productName) }
            allSelectedProducts.append(contentsOf: selectedProducts)
            firstProducts = savedProductNames.count
        }
        if let savedProductNames = UserDefaults.standard.array(forKey: "selectedProductsForSecondClient_\(tables[selectedTableIndex])") as? [String] {
            let selectedProducts = menuProducts.filter { savedProductNames.contains($0.productName) }
            allSelectedProducts.append(contentsOf: selectedProducts)
            secondProducts = savedProductNames.count
        }
        if let savedProductNames = UserDefaults.standard.array(forKey: "selectedProductsForThirdClient_\(tables[selectedTableIndex])") as? [String] {
            let selectedProducts = menuProducts.filter { savedProductNames.contains($0.productName) }
            allSelectedProducts.append(contentsOf: selectedProducts)
            thirdProducts = savedProductNames.count
        }
        if let savedProductNames = UserDefaults.standard.array(forKey: "selectedProductsForFourthClient_\(tables[selectedTableIndex])") as? [String] {
            let selectedProducts = menuProducts.filter { savedProductNames.contains($0.productName) }
            allSelectedProducts.append(contentsOf: selectedProducts)
            fourthProducts = savedProductNames.count
        }
        if let mainVC = mainVC, let tableIndex = tableIndex {
            if let cell = mainVC.tables.cellForRow(at: tableIndex) as? TableEditTableViewCell {
                tableNumberLabel.text = cell.tableNumberLabel.text
                client1Bill.text = cell.priceLabel1.text
                client2Bill.text = cell.priceLabel2.text
                client3Bill.text = cell.priceLabel3.text
                client4Bill.text = cell.priceLabel4.text
                tableBill.text = cell.tableBillLabel.text
            } 
        } else {
            debugPrint("mainVC или tableIndex равен nil")
        }
    }
    
    @IBAction func backButton(_ segue: UIStoryboardSegue) {
        debugPrint("На экране счета")
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        allSelectedProducts.removeAll()
        firstProducts = 0
        secondProducts = 0
        thirdProducts = 0
        fourthProducts = 0
        tables.removeAll()
        selectedTableIndex = 0
        self.dismiss(animated: true)
        debugPrint("Все очистилось")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailBillViewController {
            detailVC.allSelectedProducts = allSelectedProducts
            detailVC.firstProducts = firstProducts
            detailVC.secondProducts = secondProducts
            detailVC.thirdProducts = thirdProducts
            detailVC.fourthProducts = fourthProducts
            detailVC.tables = tables
            detailVC.selectedTableIndex = selectedTableIndex
        }
    }
    
}
