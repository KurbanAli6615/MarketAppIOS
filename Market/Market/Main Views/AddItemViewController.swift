//
//  AddItemViewController.swift
//  Market
//
//  Created by KurbanAli on 30/12/20.
//

import UIKit

class AddItemViewController: UIViewController {
    
    //    MARK:- IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //    MARK:- Vars
    var category: Category!
    var itemImages: [UIImage?] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(category.id)
    }
    
    //    MARK:- IBActions
    
    
    @IBAction func doneBarButtonPressed(_ sender: Any) {
        dismissKeyboard()
        if checkFieldsAreCompleted(){
            saveToFirebase()
        }
        else{
            print("Fieds Are required")
            //            TODO: show error
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
    }
    
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    //    MARK:- Halper Functions
    
    private func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    private func checkFieldsAreCompleted()->Bool{
        return (titleTextField.text != "" && priceTextField.text != "" && descriptionTextView.text != "")
    }
    
    private func popTheView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //    MARK:- Save Items
    
    private func saveToFirebase(){
        let item = Item()
        item.id = UUID().uuidString
        item.name = titleTextField.text!
        item.categoryId = category.id
        item.description = descriptionTextView.text!
        item.price = Double(priceTextField.text!)
        
        if itemImages.count > 0{
            
        } else{
            saveItemToFirestore(item)
            popTheView()
        }
        
    }
}
