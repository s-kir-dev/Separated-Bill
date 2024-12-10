//
//  AccountTypeViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 11.11.2024.
//

import UIKit

class AccountTypeViewController: UIViewController {
    
    let cafeID = UUID().uuidString
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var typeSegmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(cafeID, forKey: "CafeID")
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc func nextButtonTapped() {
        switch typeSegmented.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set("Waiter", forKey: "AccountType")
            performSegue(withIdentifier: "waiterVC", sender: self)
        case 1:
            UserDefaults.standard.set("Admin", forKey: "AccountType")
            performSegue(withIdentifier: "adminVC", sender: self)
        case 2:
            UserDefaults.standard.set("Cook", forKey: "AccountType")
            performSegue(withIdentifier: "cookVC", sender: self)
        default:
            print("Добавлю еще тип потом")
        }
        UserDefaults.standard.set(cafeID, forKey: "CafeID")
    }
    
    

}
