//
//  IteamsTableViewController.swift
//  Market
//
//  Created by KurbanAli on 30/12/20.
//

import UIKit
import EmptyDataSet_Swift

class IteamsTableViewController: UITableViewController {

//    MARK: Vars
    
    var category:Category?
    var itemArray: [Item] = []
    
//    MARK:- Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.title = category?.name
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
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
    
    
    //     MARK: - table view delegate

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(itemArray[indexPath.row])
    }
    
//     MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        if segue.identifier == "itemsToAddItemSeg"{
            let vc = segue.destination as! AddItemViewController
            vc.category = category!
        }
        
    }
    
    private func showItemView(_ item: Item){
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as ItemViewController
        
        itemVC.item = item
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }

    //     MARK: - Load Items
    
    private func loadItems(){
        downloadItemsFromFirebase(withCaegoryId: category!.id) { (allItems) in
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }
}

extension IteamsTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No Items to display")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyData")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Please check back later")
    }
}
