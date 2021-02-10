//
//  AdminLoginViewController.swift
//  Market
//
//  Created by KurbanAli on 10/02/21.
//

import UIKit
import JGProgressHUD

class AdminLoginViewController: UIViewController {
    
    //    MARK:-
    
    let hud = JGProgressHUD(style: .dark)
    
    //    MARK:- IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //    MARK:- ViewLife Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //    MARK:- IBActions
    
    @IBAction func cancelBarButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if isFieldsAreNotEmpty(){
            
        }else {
            hud.textLabel.text = "All Fields are required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    //    MARK:- Halpers
    
    func isFieldsAreNotEmpty() -> Bool{
        return emailTextField.text! != "" && passwordTextField.text! != ""
    }
    
    func cleareTextFields(){
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
//    MARK:- Admin Login Functions
    
}

