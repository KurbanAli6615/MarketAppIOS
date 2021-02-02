//
//  OrdersViewController.swift
//  Market
//
//  Created by KurbanAli on 30/01/21.
//

import UIKit

class OrdersViewController: UIViewController {
    
    //    MARK:- Vars
    
    var orderArray: [Order] = []
    var itemInCurrentOrder: [Item] = []

    //    MARK:- IBoutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //    MARK:- View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        registerCell()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (MUser.currentUser() != nil){
            downloadOrder()
            
        }else{
            print("Please Login First")
        }
    }
    
//    MARK:- Register Cell
    
    func registerCell() {
        let nibName = UINib(nibName: "OrderTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "OrderTableViewCell")
    }
    
    //  MARK:- Halpers
    
    func downloadOrder(){
        downloadFromOrders(MUser.currentId()) { (allOrders) in
            self.orderArray = allOrders
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //    MARK:- Functions for the download items from Order collection
    
    private func downloadFromOrders(_ ownerID: String, complition: @escaping (_ itemArray: [Order]) -> Void){
        
        var items: [Order] = []
        
        FirebaseReference(.Orders).whereField(kOWNERID, isEqualTo: ownerID).getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    items.append(Order.init(_dictionary: document.data() as NSDictionary))
                }
            }
            complition(items)
        }
    }
    
    //    MARK:- download items from firebase

     func downloadItemsPerOrder(itemIds: [String], complition: @escaping(_ itemName:[Item]) -> Void){
       
       var itemArray:[Item] = []
       
       for i in itemIds{
           FirebaseReference(.Items).whereField(kOBJECTID, isEqualTo: i).getDocuments { (snapshot, error) in
               if error == nil {
                   for document in snapshot!.documents{
                       itemArray.append(Item.init(_dictionary: document.data() as NSDictionary))
                   }
               }else {
                   print("Error to download item from order")
               }
               print(itemArray.count)
               complition(itemArray)
           }
       }
    }
}

// MARK:- Extension for the tableView Methods
extension OrdersViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        cell.orderDetails = orderArray[indexPath.row]
        
        downloadItemsPerOrder(itemIds: orderArray[indexPath.row].orderedItemsIds) { (allItems) in
            self.itemInCurrentOrder = allItems
            
            var itemName = ""
            for (i,name) in self.itemInCurrentOrder.enumerated(){
                
                if i != self.itemInCurrentOrder.count - 1 {
                    itemName += name.name + ", "
                } else {
                    itemName += name.name
                }
            }
            print(itemName)
            cell.orderNameLabel.text = itemName
        }
        return cell
    }
}
