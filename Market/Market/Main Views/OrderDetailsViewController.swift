//
//  OrderDetailsViewController.swift
//  Market
//
//  Created by KurbanAli on 03/02/21.
//

import UIKit

class OrderDetailsViewController: UIViewController {
    
    
    //    MARK:- Vars
    
    var order: Order?
    var itemIdsInOrder: [String] = []
    var itemsInOrder: [Item] = []
    
    //    MARK:- IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //    MARK:- View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        let rightBarButton = UIBarButtonItem(title: "Cancel Order", style: UIBarButtonItem.Style.plain, target: self, action: #selector(OrderDetailsViewController.cancelOrderButtonTapped))
        
        rightBarButton.tintColor = UIColor.red
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        itemIdsInOrder = []
        createArrayOfItems()
        downloadItems()
    }
    
    //    MARK:- IBActions
    
    @objc func cancelOrderButtonTapped(){
        print("Cancel Order")
        showAlert()
    }
    
    func confirmCancelOrder(action: UIAlertAction) {
        print("confirm cancel called")
        deleteOrder()
    }
    
    
    //    MARK:- Haplers
    func createArrayOfItems(){
        for item in order!.orderedItemsIds {
            itemIdsInOrder.append(item)
        }
    }
    
    func deleteOrder(){
        FirebaseReference(.Orders).document(order!.id).delete()
        popViewController()
    }

    
    func deleteItemFromOrderFromFirestore(withValues: [String : Any], complition: @escaping(_ error: Error?) -> Void){
        FirebaseReference(.Orders).document(order!.id).updateData(withValues) { (error) in
            complition(error)
        }
    }
    
    func popViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateOrderTotal(index:Int) -> Double{
        return (order!.orderTotal - itemsInOrder[index].price)
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Cancel Order", message: "Are you sure want to cancel order ?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        
        alert.addAction(UIAlertAction(title: "Cancel Order", style: UIAlertAction.Style.default, handler: confirmCancelOrder))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //    MARK:- Item Downloader
    
    func downloadItems(){
        Market.downloadItems(itemIdsInOrder) { (allItems) in
            self.itemsInOrder = allItems
            self.tableView.reloadData()
        }
    }
}


extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsInOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(itemsInOrder[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete{
            itemIdsInOrder.remove(at: indexPath.row)
            
            var orderTotal: Double = updateOrderTotal(index: indexPath.row)
            
            if (itemIdsInOrder.count == 0){
                deleteOrder()
            }else {
                deleteItemFromOrderFromFirestore(withValues: [kORDERITEMSIDS : itemIdsInOrder, kORDERTOTAL : orderTotal]) { (error) in
                    if error != nil {
                        print("Error in updating Order", error!.localizedDescription)
                    }
                    self.downloadItems()
                }
            }
        }
    }
}
