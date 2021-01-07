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
    @IBOutlet weak var BasketTotalPriceLabel: UILabel!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOutButtonOutlet: UIButton!
    
    //    MARK:- Vars
    
    var basket: Basket?
    var allItems: [Item] = []
    var purchaseItemIds: [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    //    MARK:- View Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        TODO: User logged in or not
        loadBasketFromFirestore()
    }
    
    //    MARK:- IBActions
    @IBAction func checkOutButtonPressed(_ sender: Any) {
        
    }
    
    //    MARK:- Download Basket
    private func loadBasketFromFirestore(){
        downloadBasketFromFirestore("1234") { (basket) in
            self.basket = basket
            self.getBasketItems()
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
        return "Total Price : " + convertToCurrency(totalPrice)
    }
    //    MARK:- Navigation
    
    private func showItemView(withItem: Item) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as ItemViewController
        
        itemVC.item = withItem
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    //    MARK:- Control check out button
    
    private func checkOutButtonStatusUpdate(){
        self.checkOutButtonOutlet.isEnabled = allItems.count > 0
        
        if checkOutButtonOutlet.isEnabled{
            checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 0.9157105684, green: 0.5526917577, blue: 0.5250652432, alpha: 1)
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


