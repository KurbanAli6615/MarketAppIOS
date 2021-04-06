//
//  TermsAndPrivacyViewController.swift
//  Market
//
//  Created by KurbanAli on 06/04/21.
//

import UIKit

class TermsAndPrivacyViewController: UIViewController {
    
    
    @IBOutlet weak var txt1: UITextView!
    @IBOutlet weak var txt2: UITextView!
    @IBOutlet weak var txt3: UITextView!
    @IBOutlet weak var txt4: UITextView!
    @IBOutlet weak var txt5: UITextView!
    @IBOutlet weak var txt6: UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt1.isEditable = false
        txt2.isEditable = false
        txt3.isEditable = false
        txt4.isEditable = false
        txt5.isEditable = false
        txt6.isEditable = false
    }

}
