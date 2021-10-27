//
//  BasketViewController.swift
//  Market
//
//  Created by KurbanAli on 05/01/21.
//

import UIKit
import JGProgressHUD

class BasketViewController: UIViewController {
    
    //    MARK:- IBOutlets
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var itemsInBasketLabel: UILabel!
    @IBOutlet weak var BasketTotalPriceLabel: UILabel!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOutButtonOutlet: UIButton!
    
    //    MARK:- Vars
    
  
    var allItems: [Item] = []
    var purchaseItemIds: [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    //    MARK:- View Life cycles
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkButtonAndOutletStatus()
        checkOutButtonOutlet.layer.cornerRadius = 15
        
        navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "#657c89")
        if MUser.currentUser() != nil{
            loadBasketFromFirestore()
        }else {
            allItems = []
            self.tableView.reloadData()
            self.updateTotalLable(true)
        }
    }
    
    
    
    //    MARK:- IBActions
    @IBAction func checkOutButtonPressed(_ sender: Any) {
        
        if MUser.currentUser()!.onBoard {
            
            addItemIdsToPurchaseHistoryVeriable()
            showConfirmOrder()
        }else {
            self.hud.textLabel.text = "Please Complete Your Profile"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }
    

    
    private func getBasketItems(){
        if basket != nil{
            downloadItems(basket!.itemIds) { (allItems) in
                self.allItems = allItems
                self.updateTotalLable(false)
                self.tableView.reloadData()
            }
        }
    }
    
    //    MARK:- halper Functions
    
    

    
    private func updateTotalLable(_ isEmpty: Bool){
        if isEmpty{
            totalItemsLabel.text = "0"
            BasketTotalPriceLabel.text = returnBasketTotalPrice()
        }
        else{
            totalItemsLabel.text = "\(allItems.count)"
            BasketTotalPriceLabel.text = returnBasketTotalPrice()
        }
        checkOutButtonStatusUpdate()
    }
    
    private func returnBasketTotalPrice() -> String {
        var totalPrice = 0.0
        
        for item in allItems{
            totalPrice += item.price
        }
        return "Total : " + convertToCurrency(totalPrice)
    }
    
    private func emptyTheBasket(){
        purchaseItemIds.removeAll()
        allItems.removeAll()
        tableView.reloadData()
        
        basket!.itemIds = []
        updateBasketInFirestore(basket!, withValues: [kITEMIDS : basket!.itemIds]) { (error) in
            if error != nil {
                print("Error updating basket ",error!.localizedDescription)
            }else {
                self.getBasketItems()
            }
        }
    }
    
    private func addItemIdsToPurchaseHistoryVeriable(){
        for i in allItems{
            purchaseItemIds.append(i.id)
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
    //    MARK:- Navigation
    
    private func showItemView(withItem: Item) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as ItemViewController
        
        itemVC.item = withItem
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    private func showConfirmOrder(){
        let confirmOrderVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "confirmOrder") as ConfirmOrderViewController
        confirmOrderVc.items = allItems
        confirmOrderVc.basket = basket
        confirmOrderVc.purchaseItemIds = purchaseItemIds
        self.navigationController?.pushViewController(confirmOrderVc, animated: true)
    }
    
    //    MARK:- Control check out button
    
    private func checkOutButtonStatusUpdate(){
        self.checkOutButtonOutlet.isEnabled = allItems.count > 0
        
        if checkOutButtonOutlet.isEnabled{
            checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 0, green: 0.605456233, blue: 0, alpha: 1)
        }else {
            disableCheoutButton()
        }
    }
    
    private func disableCheoutButton(){
        checkOutButtonOutlet.isEnabled = false
        checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    private func removeItemFromBasket(itemId: String) {
        for i in 0..<basket!.itemIds.count {
            if itemId == basket!.itemIds[i]{
                basket!.itemIds.remove(at: i)
                return
            }
        }
    }
}


extension BasketViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if allItems.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            if MUser.currentUser() != nil {
                noDataLabel.text = "Your Basket is Empty !!!"
            }else {
                noDataLabel.text = "Please Login first !"
            }
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(allItems[indexPath.row])
        
        return cell
    }
    
    //    MARK:- UITable view delegate
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let itemToDelete = allItems[indexPath.row]
            
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            removeItemFromBasket(itemId: itemToDelete.id)
            
            updateBasketInFirestore(basket!, withValues: [kITEMIDS : basket!.itemIds]) { (error) in
                if error != nil {
                    print("Error in updating the basket ", (error!.localizedDescription))
                }
                self.getBasketItems()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
    }
}


