//
//  AdminOrderViewController.swift
//  Market
//
//  Created by KurbanAli on 04/03/21.
//

import UIKit
import NVActivityIndicatorView

class AdminOrderViewController: UIViewController {
    
    //    MARK:- Vars
    
    var order:Order!
    var allItemsInOrder = [Item]()
    var activityIndicator: NVActivityIndicatorView?
    
    //    MARK:-IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deliveryStatusButtonOutlet: UIButton!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var orderTotalLabel: UILabel!
    
    //    MARK:-View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        setOwnerName()
        downloadItemsFromOrder()
    }
    
    //    MARK:-IBActions
    
    @IBAction func deliveryStatusButtonTapped(_ sender: Any) {
        showAlert()
    }
    
    @objc func updateOrderStatus(action: UIAlertAction){
        showLoadingIndicator()
        FirebaseReference(.Orders).document(order.id).updateData([kISDELIVERED : true]) { (error) in
            if error != nil {
                print("Error in update order status in firebase ",error!.localizedDescription)
            } else {
                self.hideLoadingIndicator()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
//    MARK:- Halpers
    
    func setupUI(){
        deliveryStatusButtonOutlet.layer.cornerRadius = 15
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        orderTotalLabel.text = convertToCurrency(order!.orderTotal)
    }
    
    func setOwnerName() {
        ownerName { (name, error) in
            if error == nil {
                self.ownerNameLabel.text = name
            }
        }
    }
    
    func ownerName(complition: @escaping(_ name : String,_ error : Error?) -> Void) {
        
        var owner: MUser?
        
        FirebaseReference(.User).document(order.ownerID).getDocument { (snapShot, error) in
            if error == nil {
                 owner = MUser.init(_dictionary: snapShot?.data() as! NSDictionary)
                complition(owner!.fullName,nil)
            } else {
                print("Error in fetch owner name ",error!.localizedDescription)
                complition("",nil)
            }
        }
    }
    
    private func downloadItemsFromOrder(){
        downloadItems(order!.orderedItemsIds) { (allItems) in
            self.allItemsInOrder = allItems
            self.tableView.reloadData()
        }
    }
    
    
    func showAlert(){
        let alert = UIAlertController(title: "Change Delivery Status", message: "Are you sure to change status ?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: updateOrderStatus))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //    MARK:- Activity indicator
    
    private func showLoadingIndicator(){
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    private func hideLoadingIndicator(){
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
}

extension AdminOrderViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allItemsInOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(allItemsInOrder[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
