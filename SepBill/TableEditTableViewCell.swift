//
//  TableEditTableViewCell.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 14.10.24.
//

import UIKit

class TableEditTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var tableNumberLabel: UILabel!
    @IBOutlet weak var tableBillLabel: UILabel!
    @IBOutlet weak var tableImage: UIImageView!

    @IBOutlet weak var client1Button: UIButton!
    @IBOutlet weak var client2Button: UIButton!
    @IBOutlet weak var client3Button: UIButton!
    @IBOutlet weak var client4Button: UIButton!
    @IBOutlet weak var client5Button: UIButton!
    @IBOutlet weak var client6Button: UIButton!

    @IBOutlet weak var priceLabel1: UILabel!
    @IBOutlet weak var priceLabel2: UILabel!
    @IBOutlet weak var priceLabel3: UILabel!
    @IBOutlet weak var priceLabel4: UILabel!
    @IBOutlet weak var priceLabel5: UILabel!
    @IBOutlet weak var priceLabel6: UILabel!

    // MARK: - Properties
    var clients: [UIButton] = []
    var priceLabels: [UILabel] = []
    var personCount: Int = 0

    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()

        // Собираем массивы для кнопок клиентов и их меток цены
        clients = [client1Button, client2Button, client3Button, client4Button, client5Button, client6Button]
        priceLabels = [priceLabel1, priceLabel2, priceLabel3, priceLabel4, priceLabel5, priceLabel6]

        // Отключаем выделение ячейки
        self.selectionStyle = .none
        
        // Начальная установка UI
        updateUIForClients()
    }

    // MARK: - UI Update Methods
    func updateUIForClients() {
        print("Updating UI for \(personCount) clients") // Debugging
        for i in 0..<6 {
            if i < personCount {
                clients[i].isHidden = false
                priceLabels[i].isHidden = false
            } else {
                clients[i].isHidden = true
                priceLabels[i].isHidden = true
            }
        }
    }

    // MARK: - Delegate Methods
    func didUpdatePersonsCount(_ personsCount: Int) {
        self.personCount = personsCount
        updateUIForClients() // Обновляем интерфейс, если изменилось количество людей
    }

//    func didUpdateTotalPrice(_ totalPrice: Double) {
//        updatePriceLabels(totalPrice)
//    }

    // MARK: - Selection Handling
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
