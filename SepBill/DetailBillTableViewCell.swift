//
//  DetailBillTableViewCell.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 23.10.24.
//

import UIKit

class DetailBillTableViewCell: UITableViewCell {

    @IBOutlet weak var orderedByLabel: UILabel!
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productDescription: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
