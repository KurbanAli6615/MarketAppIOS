//
//  PurchaseHistoryTableViewController.swift
//  Market
//
//  Created by KurbanAli on 08/01/21.
//

import UIKit

class PurchaseHistoryTableViewController: UITableViewController {

//    MARK:- Vars
    
    var itemArray: [Item] = []
    
//    MARK:- view lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadItems()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell

        cell.generateCell(itemArray[indexPath.row])
        return cell
    }
  
//    MARK:- Load items
    
    private func loadItems(){
        downloadItems(MUser.currentUser()!.purchaseItemIds) { (allItems) in
            self.itemArray = allItems
            print("We have ", allItems.count)
            self.tableView.reloadData()
        }
    }
}
