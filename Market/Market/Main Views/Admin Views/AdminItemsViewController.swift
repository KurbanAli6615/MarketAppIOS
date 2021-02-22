//
//  AdminItemsViewController.swift
//  Market
//
//  Created by KurbanAli on 18/02/21.
//

import UIKit

class AdminItemsViewController: UIViewController {

//    MARK:- Vars
    
    var category: Category?
    var allItemsInCategory:[Item] = []
   
    //    MARK:-  IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //    MARK:-  View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadItems()
    }
    
//    MARK:- Halpers Functions
    
    func downloadItems(){
        downloadItemsFromFirebase(withCaegoryId: category!.id) { (allItems) in
            self.allItemsInCategory = allItems
            self.tableView.reloadData()
        }
    }
    
//    MARK:- Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItemSeg" {
            let vc = segue.destination as! AddItemViewController
            vc.category = self.category
        }
        
        if segue.identifier == "itemsToUpdateItem" {
            let vc = segue.destination as! AdminUpdateItemViewController
            vc.item = sender as! Item
        }
    }
}


extension AdminItemsViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allItemsInCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ItemTableViewCell
        
        cell.generateCell(allItemsInCategory[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemsToUpdateItem", sender: allItemsInCategory[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

