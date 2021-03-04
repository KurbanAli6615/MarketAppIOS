//
//  AdminOrdersTableViewCell.swift
//  Market
//
//  Created by KurbanAli on 01/03/21.
//

import UIKit

class AdminOrdersTableViewCell: UITableViewCell {

    
//    MARK:- IBOutlets
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var orderItemsLabel: UILabel!
    @IBOutlet weak var orderTotalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
