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
        print(category!.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadItems()
    }
    
//    MARK:- Halpers Functions
    
    func downloadItems(){
        downloadItemsFromFirebase(withCategoryId: category!.id) { (allItems) in
            self.allItemsInCategory = allItems
            print(allItems.count)
            self.tableView.reloadData()
        }
    }
    
    func downloadItemsFromFirebase(withCategoryId: String, compliton: @escaping(_ allItems: [Item])-> Void){
        
        print(withCategoryId)
        FirebaseReference(.Items).whereField(kCATEGORYID, isEqualTo: withCategoryId).getDocuments { (snapshot, error) in
            if error == nil {
                var allItems:[Item] = []
                
                for item in snapshot!.documents{
                    allItems.append(Item.init(_dictionary: item.data() as NSDictionary))
                }
                print(snapshot!.count)
                compliton(allItems)
            }else {
                print("Error in download items",error!.localizedDescription)
            }
           
        }
    }

}

extension AdminItemsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allItemsInCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ItemTableViewCell
        
        cell.generateCell(allItemsInCategory[indexPath.row])
        
        return cell
    }
    
    
}

