//
//  ConfirmOrderViewController.swift
//  Market
//
//  Created by KurbanAli on 17/01/21.
//

import UIKit
import JGProgressHUD

class ConfirmOrderViewController: UIViewController {

//    MARK:- Vars
    
    var items: [Item] = []
    let hud: JGProgressHUD = JGProgressHUD(style: .dark)
    var basket: Basket?
    var purchaseItemIds: [String] = []
    
//    MARK:- ViewLife cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    MARK:- IBActions
    @IBAction func confirmOrderTapped(_ sender: Any) {
        if MUser.currentUser() != nil {
           let order = Order()
            order.id = UUID().uuidString
            order.ownerID = MUser.currentId()
            order.orderTotal = orderTotal(item: items)
            order.orderedItemsIds = itemIdsfromItem(item: items)
            order.isDelivered = false
            
            saveOrderToFirestore(order: order)
            addItemsToPurchaseHistory(purchaseItemIds)
            emptyTheBasket()
        }
    }
    
//    MARK:- Halpers
    
    private func orderTotal(item: [Item]) -> Double {
        var orderTotal: Double = 0
        for i in item {
            orderTotal += i.price
        }
        return orderTotal
    }
    
    private func itemIdsfromItem(item: [Item]) -> [String]{
        var itemIds:[String] = []
        for i in item {
            itemIds.append(i.id)
        }
        return itemIds
    }
    
    
    private func emptyTheBasket(){
        
        basket!.itemIds = []
        updateBasketInFirestore(basket!, withValues: [kITEMIDS : basket!.itemIds]) { (error) in
            if error != nil {
                print("Error updating basket ",error!.localizedDescription)
            }
        }
    }
    
    private func addItemsToPurchaseHistory(_ itemIds: [String]) {
        if MUser.currentUser() != nil {
            let newItemIds = MUser.currentUser()!.purchaseItemIds + itemIds
            
            updateCurrentUserInFirestore(withValues: [kPURCHASEDITEMIDS : newItemIds]) { (error) in
                if error != nil {
                    print("Error add purchase items " ,error!.localizedDescription)
                }
            }
        }
    }
}

 
