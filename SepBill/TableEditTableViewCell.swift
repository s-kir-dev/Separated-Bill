//
//  TableEditTableViewCell.swift
//  SepBill
//
//  Created by Кирилл Сысоев on 14.10.24.
//

import UIKit

class TableEditTableViewCell: UITableViewCell {

    @IBOutlet weak var tableNumber: UILabel!
    
    @IBOutlet weak var tableImage: UIImageView!
    
    @IBOutlet weak var clientBillLabel: UILabel!
    
    @IBOutlet weak var tableBillLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
