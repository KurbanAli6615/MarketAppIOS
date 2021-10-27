//
//  ConfirmOrderViewController.swift
//  Market
//
//  Created by KurbanAli on 17/01/21.
//

import UIKit
import JGProgressHUD

class ConfirmOrderViewController: UIViewController {
    
//     MARK:- IBOutlets
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var confirmOrderButtonOutlet: UIButton!
    
    //    MARK:- Vars
    
    var items: [Item] = []
    let hud: JGProgressHUD = JGProgressHUD(style: .dark)
    var basket: Basket?
    var purchaseItemIds: [String] = []
    
//    MARK:- ViewLife cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUi()
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
            popViewController()
        }
    }
    
//    MARK:- Halpers
    
    
    private func itemIdsfromItem(item: [Item]) -> [String]{
        var itemIds:[String] = []
        for i in item {
            itemIds.append(i.id)
        }
        return itemIds
    }
        
    
    private func itemIdsfromItem(item: [Item]) -> [String]{
        var itemIds:[String] = []
        for i in item {
            itemIds.append(i.id)
        }
        return itemIds
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

 

