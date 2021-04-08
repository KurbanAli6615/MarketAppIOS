//
//  AdminManageOrdersViewController.swift
//  Market
//
//  Created by KurbanAli on 01/03/21.
//

import UIKit
import NVActivityIndicatorView
import EmptyDataSet_Swift

class AdminManageOrdersViewController: UIViewController {
    
    //    MARK:- Vars
    
    var allOrders = [Order]()
    var activityIndicator: NVActivityIndicatorView?
    
    //    MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //    MARK:- View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30 , width: 60, height: 60), type: .circleStrokeSpin , color: #colorLiteral(red: 0.9100239873, green: 0.4986173511, blue: 0.4462146759, alpha: 1), padding: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNib()
        downloadOrders()
    }
    

    //    MARK:- Activity indicator
    
    private func showLoadingIndicator(){
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
        }
    }
    
    private func hideLoadingIndicator(){
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    //    MARK:- Halpers
    func registerNib() {
        let cell = UINib(nibName: "AdminOrdersTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "AdminOrdersTableViewCell")
        tableView.rowHeight = 80
    }
    
    func downloadOrders(){
        showLoadingIndicator()
        FirebaseReference(.Orders).whereField(kISDELIVERED, isEqualTo: false).getDocuments { (snapshot, error) in
            if error == nil {
                
                var orders:[Order] = []
                for i in snapshot!.documents {
                    orders.append(Order.init(_dictionary: i.data() as NSDictionary))
                }
                
                self.allOrders = orders
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else {
                print("Error In download Order ", error!.localizedDescription)
            }
        }
        hideLoadingIndicator()
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
    
//    MARK:- Downlod Owner name
    func downloadOwnerName(userId:String, complition: @escaping(_ name: String)->Void) {
        FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
            if error == nil {
                let user = MUser.init(_dictionary: snapshot!.data()! as NSDictionary)
                complition(user.fullName)
            }
        }
    }
    
//    MARK:- Navigations
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ordersToOrder" {
            let destinationVC = segue.destination as! AdminOrderViewController
            destinationVC.order = sender as! Order
        }
    }
    
}


//    MARK:-  TableView Extensions

extension AdminManageOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if allOrders.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text = "No Orders to manage !!!"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminOrdersTableViewCell") as! AdminOrdersTableViewCell
        
        downloadItemsPerOrder(itemIds: allOrders[indexPath.row].orderedItemsIds) { (allItems) in
            
            var items = allItems
            var itemName = ""
            for (i,name) in items.enumerated(){
                if i != items.count - 1 {
                    itemName += name.name + ", "
                } else {
                    itemName += name.name
                }
            }
            cell.orderItemsLabel.text = itemName
        }
        downloadOwnerName(userId: allOrders[indexPath.row].ownerID) { (name) in
            cell.ownerNameLabel.text = name
        }
        cell.orderTotalLabel.text = convertToCurrency(allOrders[indexPath.row].orderTotal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ordersToOrder", sender: allOrders[indexPath.row])
    }
    
}
