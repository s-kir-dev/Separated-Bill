//
//  OrdersTableViewCell.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 29.11.2024.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var tableNumber: UILabel!
    @IBOutlet weak var clientNumber: UILabel!
    @IBOutlet weak var quantity: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
