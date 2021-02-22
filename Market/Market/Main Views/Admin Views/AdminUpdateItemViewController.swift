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
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemDescription: UITextView!
    
    //    MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setOldValues()
    }
    
    //    MARK:-IBActions
    @IBAction func updateButtonTapped(_ sender: Any) {
        updateItem()
    }
    
//    MARK:- Halpers
    
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
}

