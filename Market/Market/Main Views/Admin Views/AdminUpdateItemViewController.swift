//
//  AdminUpdateItemViewController.swift
//  Market
//
//  Created by KurbanAli on 22/02/21.
//

import UIKit
import JGProgressHUD

class AdminUpdateItemViewController: UIViewController {
    
    //    MARK:- Vars
    
    var item: Item?
    
    
    //    MARK:-IBOutlets
    
    @IBOutlet weak var itemStatusButtonOutlet: UIButton!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemDescription: UITextView!
    
    //    MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setOldValues()
        setButtonUI()
    }
    
    //    MARK:-IBActions
    @IBAction func updateButtonTapped(_ sender: Any) {
        updateItem()
    }
    @IBAction func itemStatusButtonPressed(_ sender: Any) {
        showAlert()
    }
    
//    MARK:- Halpers
    
    func setButtonUI(){
        itemStatusButtonOutlet.layer.cornerRadius = 17
        if item!.isActive{
            itemStatusButtonOutlet.setTitle("Deactive", for: .normal)
            itemStatusButtonOutlet.backgroundColor = #colorLiteral(red: 0, green: 0.7208622694, blue: 0.1785242856, alpha: 1)
        }else {
            itemStatusButtonOutlet.setTitle("Active", for: .normal)
            itemStatusButtonOutlet.backgroundColor = UIColor.red
        }
    }
    
    func setOldValues(){
        itemName.text = item!.name
        itemPrice.text = String(item!.price)
        itemDescription.text = item!.description
    }
    
    func updateItem(){
        FirebaseReference(.Items).document(item!.id).updateData([kNAME:itemName!.text,kPRICE:Double(itemPrice!.text ?? ""),kDESCRIPTION:itemDescription.text]) { (error) in
            if error == nil {
                print("Item Update Success")
                self.popView()
            } else {
                print("Error in Update Item ",error!.localizedDescription)
            }
        }
    }
    
    func popView(){
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(){
        let alert = UIAlertController(title: item!.isActive ? "Deactive" : "Active", message: item!.isActive ? "Are you sure want to Deactive item ?" : "Are you sure want to Active item ?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)

        alert.addAction(UIAlertAction(title: item!.isActive ? "Deactive" : "Active", style: UIAlertAction.Style.cancel, handler: changeItemStatus))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeItemStatus(alert: UIAlertAction){
        FirebaseReference(.Items).document(item!.id).updateData([kISACTIVE : !item!.isActive])
        item!.isActive = !item!.isActive
        setButtonUI()
    }
}

