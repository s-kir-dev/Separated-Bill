//
//  NewProductViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 11.11.2024.
//

import UIKit

class NewProductViewController: UIViewController {
    
    var productImage: String!
    var productName: String!
    var productDescription: String!
    var productPrice: Double!
    var prouctIsSelected = false
    var productCategory: Category!
    
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        descriptionTextView.delegate = self
        addButton.addTarget(self, action: #selector(addProduct), for: .touchUpInside)
        
        setMenu()
        addToolBarToKeyboard(priceTextField)
        addDoneButtonKeyboard(descriptionTextView)
    }
    
    func setMenu() {
        // Замыкание для обработки выбора действия
        let openClosure = { [weak self] (action: UIAction) in
            print(action.title)
            
            // Меняем изображение кнопки в зависимости от выбранного действия
            switch action.title {
            case "Закуска":
                self?.typeButton.setImage(UIImage(systemName: "plus"), for: .normal)
                self?.productCategory = .snacks
            case "Десерт":
                self?.typeButton.setImage(UIImage(systemName: "birthday.cake.fill"), for: .normal)
                self?.productCategory = .desserts
            case "Суп":
                self?.typeButton.setImage(UIImage(systemName: "light.recessed.fill"), for: .normal)
                self?.productCategory = .soups
            case "Паста":
                self?.typeButton.setImage(UIImage(systemName: "fork.knife"), for: .normal)
                self?.productCategory = .pasta
            case "Горячее рыбное блюдо":
                self?.typeButton.setImage(UIImage(systemName: "fish.fill"), for: .normal)
                self?.productCategory = .hotFishDisches
            case "Горячее мясное блюдо":
                self?.typeButton.setImage(UIImage(systemName: "pawprint.fill"), for: .normal)
                self?.productCategory = .hotMeatDishes
            case "Салат":
                self?.typeButton.setImage(UIImage(systemName: "carrot.fill"), for: .normal)
                self?.productCategory = .salats
            case "Алкогольный напиток":
                self?.typeButton.setImage(UIImage(systemName: "wineglass.fill"), for: .normal)
                self?.productCategory = .drinksWithAlcohol
            case "Безалкогольный напиток":
                self?.typeButton.setImage(UIImage(systemName: "waterbottle.fill"), for: .normal)
                self?.productCategory = .drinksWithoutAlcohol
            default:
                break
            }
        }
        
        let menu = UIMenu(children: [
            UIAction(title: "Закуска", image: UIImage(systemName: "plus"), handler: openClosure),
            UIAction(title: "Десерт", image: UIImage(systemName: "birthday.cake.fill"), handler: openClosure),
            UIAction(title: "Суп", image: UIImage(systemName: "light.recessed.fill"), handler: openClosure),
            UIAction(title: "Паста", image: UIImage(systemName: "fork.knife"), handler: openClosure),
            UIAction(title: "Горячее рыбное блюдо", image: UIImage(systemName: "fish.fill"), handler: openClosure),
            UIAction(title: "Горячее мясное блюдо", image: UIImage(systemName: "pawprint.fill"), handler: openClosure),
            UIAction(title: "Салат", image: UIImage(systemName: "carrot.fill"), handler: openClosure),
            UIAction(title: "Алкогольный напиток", image: UIImage(systemName: "wineglass.fill"), handler: openClosure),
            UIAction(title: "Безалкогольный напиток", image: UIImage(systemName: "waterbottle.fill"), handler: openClosure)
        ])
        
        typeButton.menu = menu
        typeButton.showsMenuAsPrimaryAction = true
        typeButton.changesSelectionAsPrimaryAction = true
    }
    
    func addToolBarToKeyboard(_ field: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        
        field.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        if priceTextField.text?.isEmpty == false && descriptionTextView.text?.isEmpty == false && nameTextField.text?.isEmpty == false {
            addButton.isEnabled = true
        }
        
        productPrice = Double(priceTextField.text!)!
        view.endEditing(true)
    }
    
    func addDoneButtonKeyboard(_ view: UITextView) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(closeKeyboard))
        toolbar.setItems([doneButton], animated: true)
        
        view.inputAccessoryView = toolbar
    }
    
    @objc func closeKeyboard() {
        if priceTextField.text?.isEmpty == false && descriptionTextView.text?.isEmpty == false && nameTextField.text?.isEmpty == false {
            addButton.isEnabled = true
        }
        productDescription = descriptionTextView.text!
        view.endEditing(true)
    }
    
    @objc func addProduct() {
        guard let name = nameTextField.text, !name.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty,
              let priceText = priceTextField.text, let price = Double(priceText),
              let category = productCategory else {
            return
        }

        let newProduct = Product(productImage: "",
                                 productName: name,
                                 productDescription: description,
                                 productPrice: price,
                                 isSelected: prouctIsSelected,
                                 productCategory: category)

        switch category {
        case .snacks:
            Products.snacks.append(newProduct)
        case .desserts:
            Products.desserts.append(newProduct)
        case .soups:
            Products.soups.append(newProduct)
        case .pasta:
            Products.pasta.append(newProduct)
        case .hotFishDisches:
            Products.hotFishDishes.append(newProduct)
        case .hotMeatDishes:
            Products.hotMeatDishes.append(newProduct)
        case .salats:
            Products.salats.append(newProduct)
        case .drinksWithAlcohol:
            Products.drinksWithAlcohol.append(newProduct)
        case .drinksWithoutAlcohol:
            Products.drinksWithoutAlcohol.append(newProduct)
        }

        NotificationCenter.default.post(name: NSNotification.Name("ProductAdded"), object: nil)

        let message = "Товар \(name) успешно добавлен!"
        let alert = UIAlertController(title: "Успешно", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)

        nameTextField.text = ""
        priceTextField.text = ""
        descriptionTextView.text = ""
        addButton.isEnabled = false
    }

}

extension NewProductViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if priceTextField.text?.isEmpty == false && descriptionTextView.text?.isEmpty == false && nameTextField.text?.isEmpty == false {
            addButton.isEnabled = true
        }
        
        if textField.restorationIdentifier == "productName" {
            productName = textField.text
        }
        
        textField.resignFirstResponder()
        return true
    }
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        if priceTextField.text?.isEmpty == false && descriptionTextView.text?.isEmpty == false && nameTextField.text?.isEmpty == false {
            addButton.isEnabled = true
        }
        textView.resignFirstResponder()
        return true
    }
}
