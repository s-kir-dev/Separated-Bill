//
//  AccountViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 11.11.2024.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var accountSegmented: UISegmentedControl!
    
    var accountType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountType = UserDefaults.standard.string(forKey: "AccountType") ?? ""
        
        configureSegmentedControl()
        changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
    }
    
    private func configureSegmentedControl() {
        // Устанавливаем выбранный сегмент в соответствии с сохраненным типом аккаунта
        switch accountType {
        case "Waiter":
            accountSegmented.selectedSegmentIndex = 0
        case "Admin":
            accountSegmented.selectedSegmentIndex = 1
        case "Cook":
            accountSegmented.selectedSegmentIndex = 2
        default:
            accountSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
        }
    }
    
    @objc func changeButtonTapped() {
        // Получаем новый выбранный тип аккаунта
        let newAccountType: String
        switch accountSegmented.selectedSegmentIndex {
        case 0: newAccountType = "Waiter"
        case 1: newAccountType = "Admin"
        case 2: newAccountType = "Cook"
        default:
            showAlert(title: "Ошибка", message: "Выберите тип аккаунта.")
            return
        }
        
        // Проверяем, не совпадает ли он с текущим
        if accountType == newAccountType {
            showAlert(title: "Ошибка", message: "Вы уже используете этот тип аккаунта.")
            return
        }
        
        // Сохраняем новый тип аккаунта
        accountType = newAccountType
        UserDefaults.standard.set(newAccountType, forKey: "AccountType")
        
        // Переходим на соответствующий экран
        presentNextScreen(for: newAccountType)
    }
    
    private func presentNextScreen(for accountType: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier: String
        
        switch accountType {
        case "Waiter": identifier = "waiter"
        case "Admin": identifier = "admin"
        case "Cook": identifier = "cook"
        default: return
        }
        
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: identifier) as? UITabBarController {
            tabBarController.modalPresentationStyle = .fullScreen
            present(tabBarController, animated: true, completion: nil)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
