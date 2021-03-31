//
//  AdminLogoutViewController.swift
//  Market
//
//  Created by KurbanAli on 22/02/21.
//

import UIKit

class AdminLogoutViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.tableFooterView = UIView()
        tableview.rowHeight = 50
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Logout", message: "Are you sure want to logout ?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)

        alert.addAction(UIAlertAction(title: "Logout", style: UIAlertAction.Style.cancel, handler: logout))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func logout(action: UIAlertAction) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AdminLogoutViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel?.text = "Logout"
        cell?.textLabel?.textColor = UIColor.link
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.textLabel?.textAlignment = NSTextAlignment.right
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        showAlert()
    }
    
}
