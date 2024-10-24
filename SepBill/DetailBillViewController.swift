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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationTitle.title = "Подробности Стол №\(tables[selectedTableIndex])"
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSelectedProducts.count
    }
}

