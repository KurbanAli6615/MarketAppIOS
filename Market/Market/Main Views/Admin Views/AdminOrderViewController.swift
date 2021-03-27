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
    var activityIndicator: NVActivityIndicatorView?
    
    //    MARK:-IBOutlet
    
    @IBOutlet weak var deliveryStatusButtonOutlet: UIButton!
    @IBOutlet weak var ownerNameLabel: UILabel!
    
    //    MARK:-View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deliveryStatusButtonOutlet.layer.cornerRadius = 15
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setOwnerName()
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
