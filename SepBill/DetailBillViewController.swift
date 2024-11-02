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
    
    var selectedTableIndex: Int = 0
    var tables = [Int]()
    var productKolvo1: [Product: Int] = [:]
    var productKolvo2: [Product: Int] = [:]
    var productKolvo3: [Product: Int] = [:]
    var productKolvo4: [Product: Int] = [:]
    var productKolvo5: [Product: Int] = [:]
    var productKolvo6: [Product: Int] = [:]

    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationTitle.title = "Подробности Стол №\(tables[selectedTableIndex])"
        
        tableProducts.delegate = self
        tableProducts.dataSource = self

        loadProductsKolvo(1)
        loadProductsKolvo(2)
        loadProductsKolvo(3)
        loadProductsKolvo(4)
        loadProductsKolvo(5)
        loadProductsKolvo(6)

        tableProducts.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedProduct", for: indexPath) as! DetailBillTableViewCell
        
        let product: Product
        let kolvo: Int
        let clientIndex: Int
        
        // Определяем, к какому клиенту относится текущий продукт
        if indexPath.row < productKolvo1.count {
            product = Array(productKolvo1.keys)[indexPath.row]
            kolvo = productKolvo1[product] ?? 0
            clientIndex = 1
            cell.backgroundColor = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1)
        } else if indexPath.row < productKolvo1.count + productKolvo2.count {
            product = Array(productKolvo2.keys)[indexPath.row - productKolvo1.count]
            kolvo = productKolvo2[product] ?? 0
            clientIndex = 2
            cell.backgroundColor = UIColor(red: 255/255, green: 182/255, blue: 193/255, alpha: 0.5)
        } else if indexPath.row < productKolvo1.count + productKolvo2.count + productKolvo3.count {
            product = Array(productKolvo3.keys)[indexPath.row - (productKolvo1.count + productKolvo2.count)]
            kolvo = productKolvo3[product] ?? 0
            clientIndex = 3
            cell.backgroundColor = UIColor(red: 144/255, green: 0.7, blue: 144/255, alpha: 0.7)
        } else if indexPath.row < productKolvo1.count + productKolvo2.count + productKolvo3.count + productKolvo4.count  {
            product = Array(productKolvo4.keys)[indexPath.row - (productKolvo1.count + productKolvo2.count + productKolvo3.count)]
            kolvo = productKolvo4[product] ?? 0
            clientIndex = 4
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 224/255, alpha: 1)
        } else if indexPath.row < productKolvo1.count + productKolvo2.count + productKolvo3.count + productKolvo4.count + productKolvo5.count {
            product = Array(productKolvo5.keys)[indexPath.row - (productKolvo1.count + productKolvo2.count + productKolvo3.count + productKolvo4.count)]
            kolvo = productKolvo5[product] ?? 0
            clientIndex = 5
            cell.backgroundColor = UIColor(red: 224/255, green: 1, blue: 224/255, alpha: 1)
        } else {
            product = Array(productKolvo6.keys)[indexPath.row - (productKolvo1.count + productKolvo2.count + productKolvo3.count + productKolvo4.count + productKolvo5.count)]
            kolvo = productKolvo6[product] ?? 0
            clientIndex = 6
            cell.backgroundColor = UIColor(red: 1, green: 224/255, blue: 1, alpha: 1)
        }

        cell.orderedByLabel.text = "Заказал клиент \(clientIndex)"
        cell.productDescription.text = product.productDescription
        cell.productName.text = product.productName
        cell.productImage.image = UIImage(named: product.productImage)
        cell.productPrice.text = "\(product.productPrice) р."
        cell.kolvoLabel.text = "x\(kolvo)"
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productKolvo1.count + productKolvo2.count + productKolvo3.count + productKolvo4.count + productKolvo5.count + productKolvo6.count
    }

    func loadProductsKolvo(_ client: Int) {
        if let savedProductData = UserDefaults.standard.dictionary(forKey: "productQuantitiesForTable_\(tables[selectedTableIndex])_client\(client)") as? [String: Int] {
            for (productName, quantity) in savedProductData {
                if let product = findProductByName(productName) {
                    switch client {
                    case 1:
                        productKolvo1[product] = quantity
                    case 2:
                        productKolvo2[product] = quantity
                    case 3:
                        productKolvo3[product] = quantity
                    case 4:
                        productKolvo4[product] = quantity
                    case 5:
                        productKolvo5[product] = quantity
                    case 6:
                        productKolvo6[product] = quantity
                    default:
                        break
                    }
                }
            }
        }
    }

    func findProductByName(_ name: String) -> Product? {
        return products.first { $0.productName == name }
    }
}
