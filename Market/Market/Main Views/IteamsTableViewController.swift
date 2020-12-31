//
//  IteamsTableViewController.swift
//  Market
//
//  Created by KurbanAli on 30/12/20.
//

import UIKit

class IteamsTableViewController: UITableViewController {

//    MARK: Vars
    
    var category:Category?
    var itemArray: [Item] = []
    
//    MARK:- Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.title = category?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil {
            loadItems()
        }
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
    

//     MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        if segue.identifier == "itemsToAddItemSeg"{
            let vc = segue.destination as! AddItemViewController
            vc.category = category!
        }
        
    }

    //     MARK: - Load Items
    
    private func loadItems(){
        downloadItemsFromFirebase(withCaegoryId: category!.id) { (allItems) in
            print("All items: ", allItems.count)
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }

}
