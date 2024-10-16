//
//  MenuViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 15.10.24.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func updateBill(for tableNumber: Int, with totalPrice: Double)
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: MenuViewControllerDelegate?

    @IBOutlet weak var menu: UITableView!
    @IBOutlet weak var billLabel: UILabel!

    var selectedProducts: [Product] = []
    var menuProducts: [Product] = []
    var tables = [Int]()
    var selectedTableIndex: Int = 0 // Хранит индекс выбранного стола

    var client1Bill: Double = 0 {
        didSet {
            billLabel.text = "Счет: \(client1Bill) р."
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        menu.dataSource = self
        menu.delegate = self

        // Загружаем продукты в меню
        menuProducts.append(contentsOf: Products.drinksWithAlcohol)
        menuProducts.append(contentsOf: Products.drinksWithoutAlcohol)
        menuProducts.append(contentsOf: Products.snacks)
        menuProducts.append(contentsOf: Products.soups)
        menuProducts.append(contentsOf: Products.salats)
        menuProducts.append(contentsOf: Products.pasta)
        menuProducts.append(contentsOf: Products.desserts)
        menuProducts.append(contentsOf: Products.hotFishDishes)
        menuProducts.append(contentsOf: Products.hotMeatDishes)
        billLabel.text = "Счет: \(client1Bill) р."
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuProducts.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! ProductTableViewCell
        let product = menuProducts[indexPath.row]

        cell.productDescription.text = product.productDescription
        cell.productName.text = product.productName
        cell.productImage.image = UIImage(named: product.productImage)
        cell.productPrice.text = "\(product.productPrice) р."
        cell.selectedProduct.isOn = selectedProducts.contains(product)

        if selectedProducts.contains(product) {
            cell.backgroundColor = UIColor(red: 0.796, green: 0.874, blue: 0.811, alpha: 1)
        } else {
            cell.backgroundColor = .white
        }

        cell.selectedProduct.tag = indexPath.row
        cell.selectedProduct.addTarget(self, action: #selector(selectProduct(_:)), for: .valueChanged)
        cell.selectionStyle = .none

        return cell
    }

    @IBAction func selectProduct(_ sender: UISwitch) {
        let product = menuProducts[sender.tag]
        let cell = menu.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! ProductTableViewCell

        if sender.isOn {
            selectedProducts.append(product)
            client1Bill += product.productPrice // Обновляем сумму счета
            cell.backgroundColor = UIColor(red: 0.796, green: 0.874, blue: 0.811, alpha: 1)
        } else {
            if let index = selectedProducts.firstIndex(of: product) {
                selectedProducts.remove(at: index)
                client1Bill -= product.productPrice // Уменьшаем сумму счета
                cell.backgroundColor = .white
            }
        }
    }

    // Не забудьте добавить метод для передачи данных при возврате
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToMain", let mainVC = segue.destination as? MainViewController {
            mainVC.updateBill(for: tables[selectedTableIndex], with: client1Bill)
        }
    }
}
