//
//  AdminLoginViewController.swift
//  Market
//
//  Created by KurbanAli on 10/02/21.
//

import UIKit
import JGProgressHUD
import FirebaseAuth
import NVActivityIndicatorView

class AdminLoginViewController: UIViewController {
    
    //    MARK:- Vars
    
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    //    MARK:- IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //    MARK:- ViewLife Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        cleareTextFields()
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30 , width: 60, height: 60), type: .orbit , color: #colorLiteral(red: 0.9100239873, green: 0.4986173511, blue: 0.4462146759, alpha: 1), padding: nil)
    }
    
    //    MARK:- IBAtions
    
    @IBAction func cancelBarButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if isFieldsAreNotEmpty(){
            showLoadingIndicator()
            adminLogin()
        }else {
            showHudMessage(message: "All Fields are requireds")
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
    
    func showHudMessage(message: String){
        self.hud.textLabel.text = message
        self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
        self.emailTextField.becomeFirstResponder()
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
    //    MARK:- Admin Login Functions
    
    func adminLogin(){
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
            
            if error != nil {
                self.hideLoadingIndicator()
                self.showHudMessage(message: error!.localizedDescription)
                self.cleareTextFields()
            } else {
                self.checkIsAdmin(userId: authResult!.user.uid)
            }
        }
    }
    
    func checkIsAdmin(userId: String){
        FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
            
            if error == nil {
                let user = MUser.init(_dictionary: snapshot!.data() as! NSDictionary)
                
                if user.isAdmin == true {
                    // TODO: Admin Logged in
                    self.hideLoadingIndicator()
                    self.performSegue(withIdentifier: "adminToAddItem", sender: self)
                } else {
                    self.hideLoadingIndicator()
                    self.showHudMessage(message: "You are not admin")
                }
                
            } else {
                self.hideLoadingIndicator()
                self.showHudMessage(message: error!.localizedDescription)
            }
            
        }
    }
}

