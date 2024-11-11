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
    
    var isWaiter: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isWaiter = UserDefaults.standard.bool(forKey: "Waiter")
        
        accountSegmented.selectedSegmentIndex = isWaiter ? 0 : 1
        
        changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
    }
    
    @objc func changeButtonTapped() {
        let selectedIsWaiter = accountSegmented.selectedSegmentIndex == 0
        
        if isWaiter == selectedIsWaiter {
            let alert = UIAlertController(title: "Ошибка", message: "Вы уже используете этот тип аккаунта.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        isWaiter = selectedIsWaiter
        UserDefaults.standard.set(isWaiter, forKey: "Waiter")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = isWaiter ? "waiter" : "admin"
        
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: identifier) as? UITabBarController {
            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController, animated: true, completion: nil)
        }
    }
}
