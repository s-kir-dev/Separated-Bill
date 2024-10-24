//
//  DetailBillViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 23.10.24.
//

import UIKit

class DetailBillViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableProducts: UITableView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var allSelectedProducts: [Product] = []
    var selectedTableIndex: Int = 0
    var tables = [Int]()
    var firstProducts: Int = 0
    var secondProducts: Int = 0
    var thirdProducts: Int = 0
    var fourthProducts: Int = 0
    var productsKolvo: [Product: Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitle.title = "Подробности Стол №\(tables[selectedTableIndex])"
        loadProductsKolvo(for: 1)
        loadProductsKolvo(for: 2)
        loadProductsKolvo(for: 3)
        loadProductsKolvo(for: 4)
        tableProducts.delegate = self
        tableProducts.dataSource = self
        
        tableProducts.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedProduct", for: indexPath) as! DetailBillTableViewCell
        let product = allSelectedProducts[indexPath.row]

        cell.productDescription.text = product.productDescription
        cell.productName.text = product.productName
        cell.productImage.image = UIImage(named: product.productImage)
        cell.productPrice.text = "\(product.productPrice) р."
        cell.selectionStyle = .none
        
        let kolvo = productsKolvo[product] ?? 0
        cell.kolvoLabel.text = "x\(kolvo)"

        setCellBackgroundColor(cell, for: indexPath)

        return cell
    }
    
    private func setCellBackgroundColor(_ cell: DetailBillTableViewCell, for indexPath: IndexPath) {
        if indexPath.row < firstProducts {
            cell.backgroundColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1)
            cell.orderedByLabel.text = "Заказал клиент 1"
        } else if indexPath.row < firstProducts + secondProducts {
            cell.backgroundColor = UIColor(red: 255/255, green: 182/255, blue: 193/255, alpha: 0.5)
            cell.orderedByLabel.text = "Заказал клиент 2"
        } else if indexPath.row < firstProducts + secondProducts + thirdProducts {
            cell.backgroundColor = UIColor(red: 144/255, green: 0.7, blue: 144/255, alpha: 0.7)
            cell.orderedByLabel.text = "Заказал клиент 3"
        } else if indexPath.row < firstProducts + secondProducts + thirdProducts + fourthProducts {
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 224/255, alpha: 1)
            cell.orderedByLabel.text = "Заказал клиент 4"
        } else {
            cell.backgroundColor = .white
        }
    }
    
    func loadProductsKolvo(for client: Int) {
        if let savedProductData = UserDefaults.standard.dictionary(forKey: "productQuantitiesForTable_\(tables[selectedTableIndex])_client\(client)") as? [String: Int] {
            for (productName, quantity) in savedProductData {
                if let product = allSelectedProducts.first(where: { $0.productName == productName }) {
                    productsKolvo[product] = quantity
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSelectedProducts.count
    }
}
