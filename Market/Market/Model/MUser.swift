//
//  MUser.swift
//  Market
//
//  Created by KurbanAli on 07/01/21.
//

import Foundation
import FirebaseAuth

class MUser{
    
    let objectId: String
    var email: String
    var firstName: String
    var lastName: String
    var fullName: String
    var purchaseItemIds: [String]
    
    var fullAddess: String?
    var onBoard: Bool
    
    //    MARK:- init
    
    init(_objectId: String, _email: String, _firstName: String, _lastName: String) {
        objectId = _objectId
        email = _email
        firstName = _firstName
        lastName = _lastName
        fullName = _firstName + " " + _lastName
        fullAddess = ""
        purchaseItemIds = []
        onBoard = false
    }
    
    init(_dictionary: NSDictionary) {
        objectId = _dictionary[kOBJECTID] as! String
        
        if let mail = _dictionary[kEMAIL] {
            email = mail as! String
        }else {
            email = ""
        }
        
        if let fname = _dictionary[kFIRSTNAME] {
            firstName = fname as! String
        }else {
            firstName = ""
        }
        
        if let lname = _dictionary[kLASTNAME] {
            lastName = lname as! String
        }else {
            lastName = ""
        }
        
        fullName = firstName + " " + lastName
        
        if let faddress = _dictionary[kFULLADDRESS] {
            fullAddess = faddress as! String
        }else {
            fullAddess = ""
        }
        
        if let onB = _dictionary[kONBOARD] {
            onBoard = onB as! Bool
        }else {
            onBoard = false
        }
        
        if let purchasedIds = _dictionary[kPURCHASEDITEMIDS] {
            purchaseItemIds = purchasedIds as! [String]
        }else {
            purchaseItemIds = []
        }
    }
    
    //    MARK:- Return Current User
    
    class func currentId() -> String{
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> MUser? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER){
                return MUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
}
