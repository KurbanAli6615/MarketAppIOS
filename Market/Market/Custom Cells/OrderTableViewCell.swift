//
//  OrderTableViewCell.swift
//  Market
//
//  Created by KurbanAli on 31/01/21.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var deliverStatusImageView: UIImageView!
    @IBOutlet weak var orderNameLabel: UILabel!
    
    
    var orderDetails: Order? {
        didSet {
            orderTotalLabel.text = "Total: \(orderDetails?.orderTotal ?? 0)"
            orderNameLabel.text = orderDetails?.ownerID ?? ""
            if (orderDetails?.isDelivered ?? false) {
                // Todo: set delivered image
            } else {
                // Todo: set not delivered image
            }
        }
    }
    
}
