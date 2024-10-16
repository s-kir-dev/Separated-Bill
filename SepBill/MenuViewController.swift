//
//  MenuViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 15.10.24.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func didUpdateTotalPrice(_ price: Double)
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: MenuViewControllerDelegate?
    
    @IBOutlet weak var menu: UITableView!
    
    @IBOutlet weak var billLabel: UILabel!
    
    @IBAction func selectProduct(_ sender: UISwitch) {
        let product = menuProducts[sender.tag] // Определяем продукт по тегу переключателя
        
        if sender.isOn {
            // Если переключатель включен, добавляем продукт в выбранные и увеличиваем счёт
            selectedProducts.append(product)
            totalPrice += product.productPrice
        } else {
            // Если переключатель выключен, убираем продукт из выбранных и уменьшаем счёт
            if let index = selectedProducts.firstIndex(of: product) {
                selectedProducts.remove(at: index)
                totalPrice -= product.productPrice
            }
        }
    }
    
    var selectedProducts: [Product] = []
    
    var menuProducts: [Product] = []
    
    var totalPrice: Double = 0 {
        didSet {
            billLabel.text = "Счет: \(totalPrice)р."
            delegate?.didUpdateTotalPrice(totalPrice)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menu.dataSource = self
        menu.delegate = self
        menuProducts.append(contentsOf: Products.drinksWithAlcohol)
        menuProducts.append(contentsOf: Products.drinksWithoutAlcohol)
        menuProducts.append(contentsOf: Products.snacks)
        menuProducts.append(contentsOf: Products.soups)
        menuProducts.append(contentsOf: Products.salats)
        menuProducts.append(contentsOf: Products.pasta)
        menuProducts.append(contentsOf: Products.desserts)
        menuProducts.append(contentsOf: Products.hotFishDishes)
        menuProducts.append(contentsOf: Products.hotMeatDishes)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! ProductTableViewCell
        let product = menuProducts[indexPath.row]
        
        cell.productDescription.text = product.productDescription
        cell.productImage.image = UIImage(named: product.productImage)
        cell.productPrice.text = "\(product.productPrice)р."
        cell.selectedProduct.isOn = selectedProducts.contains(product) // Отображаем состояние переключателя
        
        // Добавляем цель для переключателя
        cell.selectedProduct.tag = indexPath.row // Присваиваем тег для идентификации продукта
        cell.selectedProduct.addTarget(self, action: #selector(selectProduct(_:)), for: .valueChanged)
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuProducts.count
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
