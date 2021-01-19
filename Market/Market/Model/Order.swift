//
//  Order.swift
//  Market
//
//  Created by KurbanAli on 19/01/21.
//

import Foundation

class Order{
    
    var id: String!
    var ownerID: String!
    var orderTotal: Double!
    var orderedItemsIds:[String]!
    var isDelivered: Bool!
    
    init (){}
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kORDERID] as? String
        ownerID = _dictionary[kOWNERID] as? String
        orderTotal = _dictionary[kORDERTOTAL] as? Double
        orderedItemsIds = _dictionary[kORDERITEMSIDS] as? [String]
        isDelivered = _dictionary[kISDELIVERED] as? Bool
    }
}

//    MARK:- Save order to firebase
    func saveOrderToFirestore(order: Order){
        FirebaseReference(.Orders).document(order.id).setData(orderDictionaryFrom(order) as! [String : Any])
    }
//MARK:- Helper functions

func orderDictionaryFrom(_ order: Order) -> NSDictionary {
    
    return NSDictionary(objects: [order.id, order.ownerID, order.orderTotal, order.orderedItemsIds, order.isDelivered], forKeys: [kORDERID as NSCopying, kOWNERID as NSCopying, kORDERTOTAL as NSCopying, kORDERITEMSIDS as NSCopying, kISDELIVERED as NSCopying])
}
