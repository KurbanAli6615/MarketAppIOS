//
//  EditProfileViewController.swift
//  Market
//
//  Created by KurbanAli on 08/01/21.
//

import UIKit
import JGProgressHUD


class EditProfileViewController: UIViewController {
    
//  MARK:- IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var logoutButtonOutlet: UIButton!
    
    //  MARK:- vars
    
    let hud = JGProgressHUD(style: .dark)
    
    //  MARK:- view lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
        logoutButtonOutlet.layer.cornerRadius = 20
    }
    //  MARK:- IBActions
    
    @IBAction func saveBarButtonPressed(_ sender: Any) {
        dismissKeyboard()
        
        if textFieldsHaveText(){
            
            let withValues = [kFIRSTNAME : nameTextField.text!, kLASTNAME : surnameTextField.text!, kFULLNAME : (nameTextField.text! + " " + surnameTextField.text!), kFULLADDRESS : addressTextField.text!]
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
                if error == nil {
                    self.hud.textLabel.text = "Updated!"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }else {
                    print("Error updating user ", error!.localizedDescription)
                    self.hud.textLabel.text = error!.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }
        }else {
            
            hud.textLabel.text = "All fields are requires"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        logOutUser()
    }
    
    //  MARK:- Update UI
    
    private func loadUserInfo(){
        if MUser.currentUser() != nil {
            let currentUser = MUser.currentUser()!
            
            nameTextField.text = currentUser.firstName
            surnameTextField.text = currentUser.lastName
            addressTextField.text = currentUser.fullAddess
        }
    }
    //  MARK:- halpers
    
    private func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    private func textFieldsHaveText() -> Bool{
        return nameTextField.text != "" && surnameTextField.text != "" && addressTextField.text != ""
    }
    
    private func logOutUser(){
        MUser.logOutCurrentUser { (error) in
            if error == nil {
                print("Logged Out")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Error login out ", error!.localizedDescription)
            }
        }
    }
}
