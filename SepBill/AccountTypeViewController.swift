//
//  AccountTypeViewController.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 11.11.2024.
//

import UIKit

class AccountTypeViewController: UIViewController {

    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var typeSegmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc func nextButtonTapped() {
        if typeSegmented.selectedSegmentIndex == 0 {
            UserDefaults.standard.set(true, forKey: "Waiter")
            performSegue(withIdentifier: "waiterVC", sender: self)
        } else {
            UserDefaults.standard.set(false, forKey: "Waiter")
            performSegue(withIdentifier: "adminVC", sender: self)
        }
    }
    
    

}
