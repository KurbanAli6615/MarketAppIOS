//
//  ProfileTableViewController.swift
//  Market
//
//  Created by KurbanAli on 08/01/21.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    //    MARK:- IBOutlets
    
    @IBOutlet weak var finishRegistrationButtonOutlet: UIButton!
    @IBOutlet weak var purchaseHistoryButtonOutlet: UIButton!
    
    //    MARK:- Vars
    
    var editBarButtonOutlet: UIBarButtonItem!
    
    //    MARK:- View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        Check login status
       
        checkLoginStatus()
        checkOnBoardingStatus()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
// MARK:- Halpers
    private func checkLoginStatus(){
        if MUser.currentUser() == nil {
            createRightBarButton(title: "Login")
        }else {
            createRightBarButton(title: "Edit")
            purchaseHistoryButtonOutlet.isEnabled = true
        }
    }
    
    private func createRightBarButton(title: String){
        editBarButtonOutlet = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonItemPressed))
        self.navigationItem.rightBarButtonItem = editBarButtonOutlet
    }
    
    private func checkOnBoardingStatus(){
        if MUser.currentUser() != nil {
            if MUser.currentUser()!.onBoard {
                finishRegistrationButtonOutlet.setTitle("Account is Active", for: .normal)
                finishRegistrationButtonOutlet.isEnabled = false
                
            }else {
                finishRegistrationButtonOutlet.setTitle("Finish Registration", for: .normal)
                finishRegistrationButtonOutlet.isEnabled = true
                finishRegistrationButtonOutlet.tintColor = . red
            }
        }else {
            finishRegistrationButtonOutlet.setTitle("Logged out", for: .normal)
            finishRegistrationButtonOutlet.isEnabled = false
            purchaseHistoryButtonOutlet.isEnabled = false
        }
        
    }
    
//  MARK:- IBActions
    
    @objc func rightBarButtonItemPressed(){
        if editBarButtonOutlet.title == "Login" {
            showLoginView()
        }else {
            goToEditProfile()
        }
    }
    

// MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    private func showLoginView(){
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        self.present(loginView, animated: true, completion: nil)
        
    }
    
    private func goToEditProfile(){
        performSegue(withIdentifier: "profileToEditSeg", sender: self)
    }
}
