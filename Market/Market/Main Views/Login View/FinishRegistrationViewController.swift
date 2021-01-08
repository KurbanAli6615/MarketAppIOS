//
//  FinishRegistrationViewController.swift
//  Market
//
//  Created by KurbanAli on 08/01/21.
//

import UIKit
import JGProgressHUD

class FinishRegistrationViewController: UIViewController {

//    MARK:- IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    //    MARK:- Vars
    
    let hud = JGProgressHUD(style: .dark)
    
//    MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        surnameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        addressTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
//    MARK:- IBActions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        updateDoneButtonStatus()
    }
    
    //    MARK:- Halpers
    
    private func updateDoneButtonStatus(){
        if nameTextField.text != "" && surnameTextField.text != "" && addressTextField.text != "" {
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.9095627666, green: 0.4979957938, blue: 0.4498652816, alpha: 1)
            doneButtonOutlet.isEnabled = true
        }else {
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            doneButtonOutlet.isEnabled = false
        }
    }
}
