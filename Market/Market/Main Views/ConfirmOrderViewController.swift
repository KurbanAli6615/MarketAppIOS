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
    
    @IBOutlet weak var addressTextField: UILabel!
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
        setAddress()
        navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "#657c89")
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
    
    private func setAddress(){
        if MUser.currentUser() != nil && MUser.currentUser()!.onBoard{
            addressTextField.text = MUser.currentUser()!.fullAddess
        } else {
            addressTextField.text = "Please Finish Onbording first !"
            confirmOrderButtonOutlet.isEnabled = false
        }
    }
    
    private func popViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    
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

 

