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
    
    
    //    MARK:- Haplers
     func createArrayOfItems(){
        for item in order!.orderedItemsIds {
            itemIdsInOrder.append(item)
        }
    }
    
    func confirCancelOrder(action: UIAlertAction) {
        print("confirm cancel called")
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Cancel Order", message: "Are you sure want to cancel order ?", preferredStyle: UIAlertController.Style.alert)
        
         // add the actions (buttons)
        
        alert.addAction(UIAlertAction(title: "Cancel Order", style: UIAlertAction.Style.default, handler: confirCancelOrder))
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
}
