//
//  NewMenuViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 11.11.2024.
//

import UIKit
import FirebaseStorage

class NewMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let storage = Storage.storage()
    var menuProducts: [Product] = []
    
    @IBOutlet weak var menuTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        loadMenuProducts()

        NotificationCenter.default.addObserver(self, selector: #selector(handleProductAddedNotification), name: NSNotification.Name("ProductAdded"), object: nil)
    }
    
    @objc func handleProductAddedNotification() {
        menuProducts = []
        loadMenuProducts()
        menuTableView.reloadData()
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

        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, completionHandler) in
            self.menuProducts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red.withAlphaComponent(0.9)
        deleteAction.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    func loadMenuProducts() {
        menuProducts.append(contentsOf: Products.drinksWithoutAlcohol)
        menuProducts.append(contentsOf: Products.drinksWithAlcohol)
        menuProducts.append(contentsOf: Products.hotFishDishes)
        menuProducts.append(contentsOf: Products.hotMeatDishes)
        menuProducts.append(contentsOf: Products.pasta)
        menuProducts.append(contentsOf: Products.soups)
        menuProducts.append(contentsOf: Products.salats)
        menuProducts.append(contentsOf: Products.snacks)
        menuProducts.append(contentsOf: Products.desserts)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ProductAdded"), object: nil)
    }

}
