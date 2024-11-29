//
//  MenuForSecondClientViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 16.10.24.
//

import UIKit

protocol MenuForSecondClientViewControllerDelegate: AnyObject {
    func updateSecondClientBill(for tableNumber: Int, with client2Bill: Double)
}

class MenuForSecondClientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: MenuForSecondClientViewControllerDelegate?

    @IBOutlet weak var menu: UITableView!
    @IBOutlet weak var billLabel: UILabel!

    var selectedProducts: [Product] = []
    var menuProducts: [Product] = []
    var tables = [Int]()
    var selectedTableIndex: Int = 0 // Хранит индекс выбранного стола
    
    var switchStates: [Int: Bool] = [:] // Словарь для хранения состояния свитчей
    var productQuantities: [Product: Int] = [:] // Хранит количество выбранных товаров

    var client2Bill: Double = 0 {
        didSet {
            billLabel.text = "Счет: \(client2Bill) р."
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        menu.dataSource = self
        menu.delegate = self

        // Загружаем продукты в меню
        loadMenuProducts()

        // Загружаем выбранные продукты для второго клиента
        loadSelectedProducts()

        billLabel.text = "Счет: \(client2Bill) р."
    }

    // Метод для загрузки всех продуктов в меню
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

    // Загрузка выбранных продуктов из UserDefaults
    func loadSelectedProducts() {
        if let savedProductData = UserDefaults.standard.dictionary(forKey: "productQuantitiesForTable_\(tables[selectedTableIndex])_client2") as? [String: Int] {
            for (productName, quantity) in savedProductData {
                if let product = menuProducts.first(where: { $0.productName == productName }) {
                    selectedProducts.append(product)
                    // Сохраняем количество выбранных товаров
                    productQuantities[product] = quantity
                }
            }
        }
    }

    // Сохранение выбранных продуктов в UserDefaults
    func saveSelectedProducts() {
        let selectedProductNames = selectedProducts.map { $0.productName }
        UserDefaults.standard.set(selectedProductNames, forKey: "selectedProductsForSecondClient_\(tables[selectedTableIndex])")
        
        // Сохраняем количества
        let productQuantitiesToSave = productQuantities.mapKeys { $0.productName }
        UserDefaults.standard.set(productQuantitiesToSave, forKey: "productQuantitiesForTable_\(tables[selectedTableIndex])_client2")
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuProducts.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! ProductTableViewCell
        let product = menuProducts[indexPath.row]

        // Заполняем данные ячейки
        cell.productDescription.text = product.productDescription
        cell.productName.text = product.productName
        cell.productImage.image = UIImage(named: product.productImage)
        cell.productPrice.text = "\(product.productPrice) р."

        // Устанавливаем состояние свитча
        cell.selectedProduct.isOn = switchStates[indexPath.row] ?? false

        // Устанавливаем цвет фона в зависимости от выбора
        if selectedProducts.contains(product) {
            cell.backgroundColor = cell.selectedProduct.isOn ? UIColor(red: 0.796, green: 0.874, blue: 0.811, alpha: 1) : UIColor(red: 0.796, green: 0.874, blue: 0.811, alpha: 0.5)
        } else {
            cell.backgroundColor = .white
        }

        cell.selectedProduct.tag = indexPath.row
        cell.selectedProduct.addTarget(self, action: #selector(selectProduct(_:)), for: .valueChanged)
        cell.selectionStyle = .none

        return cell
    }

    // MARK: - Продукт выбран/снят выбор
    @objc func selectProduct(_ sender: UISwitch) {
        let product = menuProducts[sender.tag]
        let cell = menu.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! ProductTableViewCell

        // Сохраняем состояние свитча
        switchStates[sender.tag] = sender.isOn

        if sender.isOn {
            // Добавляем продукт и увеличиваем счет
            selectedProducts.append(product)
            client2Bill += product.productPrice // Обновляем сумму счета второго клиента
            productQuantities[product] = (productQuantities[product] ?? 0) + 1 // Увеличиваем количество
            cell.backgroundColor = UIColor(red: 0.796, green: 0.874, blue: 0.811, alpha: 1)
        } else {
            if let index = selectedProducts.firstIndex(of: product) {
                selectedProducts.remove(at: index)
                client2Bill -= product.productPrice // Уменьшаем сумму счета второго клиента
                productQuantities[product] = max((productQuantities[product] ?? 0) - 1, 0) // Уменьшаем количество
                if productQuantities[product] == 0 {
                    productQuantities.removeValue(forKey: product)
                }
                cell.backgroundColor = .white
            }
        }

        // Сохраняем выбранные продукты
        saveSelectedProducts()

        // Обновляем метку счета при каждом выборе/снятия выбора
        billLabel.text = "Счет: \(client2Bill) р."
    }

    // Передача данных при возврате
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToMain" {
            let tableNumber = tables[selectedTableIndex] // Получаем номер стола
            delegate?.updateSecondClientBill(for: tableNumber, with: client2Bill) // Передаем счет
        }
    }
}

