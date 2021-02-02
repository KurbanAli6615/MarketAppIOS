//
//  OrderTableViewCell.swift
//  Market
//
//  Created by KurbanAli on 31/01/21.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

//    MARK:- Vars
    
    
//    MARK:- IBOutlets
    
    @IBOutlet weak var orderTotalLabel: UILabel!
    @IBOutlet weak var deliverStatusImageView: UIImageView!
    @IBOutlet weak var orderNameLabel: UILabel!
    
    
    var orderDetails: Order? {
        didSet {
            orderTotalLabel.text = "Total: \(orderDetails?.orderTotal ?? 0)"
            
            if (orderDetails?.isDelivered ?? false) {
                deliverStatusImageView.image = UIImage(named: "delivered")
            } else {
                deliverStatusImageView.image = UIImage(named: "notDelivered")
            }
        }
    }
}

