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
    
    //    MARK:- Login function
    
    class func loginUserWith(email:String, password:String, complition: @escaping (_ error: Error?,_ isEmailVerified: Bool) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error == nil{
                if authDataResult!.user.isEmailVerified {
                    
                    downloadUserFromFirestore(userId: authDataResult!.user.uid, email: email)
                    complition(error,true)
                }else {
                    print("Email Not Verified")
                    complition(error,false)
                }
            }else{
                complition(error,false)
            }
        }
    }
    
    //    MARK:- Register User
    
    class func registerUserWith(email:String, password:String, complition: @escaping(_ error: Error?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            complition(error)

            if error == nil {
//                send Email verification
                authDataResult!.user.sendEmailVerification { (error) in
                    print("Auth email verification error : ", error?.localizedDescription)
                }
            }
        }
    }
    
    
    //  MARK:- Resend Link

    class func resetPasswordFor(email: String, complition: @escaping(_ error: Error?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            complition(error)
        }
    }
    
    class func resendVerificationEmail(email: String, complition: @escaping(_ error:Error?)->Void){
        Auth.auth().currentUser?.reload(completion: { (error) in
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                print("Resend Email error ", error?.localizedDescription)
                complition(error)
            })
        })
    }
    
    class func logOutCurrentUser(complition: @escaping (_ error:Error?) -> Void){
        
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            
            complition(nil)
            
        }catch let error as NSError {
            complition(error)
        }
    }
}
// MARK: - Download user

func downloadUserFromFirestore(userId: String, email: String){
    FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
        guard let snapshot = snapshot else {return}
        
        if snapshot.exists{
            saveUserLocally(mUserDictionary: snapshot.data()! as NSDictionary )
        }else {
            let user = MUser(_objectId: userId, _email: email, _firstName: "", _lastName: "")
            
            saveUserLocally(mUserDictionary: userDictionaryFrom(user: user))
            saveUserToFirestore(mUser: user)
        }
    }
}

//  MARK:- Save user to firebase

func saveUserToFirestore(mUser: MUser) {
    FirebaseReference(.User).document(mUser.objectId).setData(userDictionaryFrom(user: mUser) as! [String : Any]) { (error) in
        if error != nil {
            print("saving user in fb ", error!.localizedDescription)
        }
    }
}

func  saveUserLocally(mUserDictionary: NSDictionary) {
    UserDefaults.standard.set(mUserDictionary, forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}

//  MARK:- Hapler fucntions

func userDictionaryFrom(user: MUser) -> NSDictionary{
    
    return NSDictionary(objects: [user.objectId, user.email, user.firstName, user.lastName, user.fullName, user.fullName ?? "", user.onBoard, user.purchaseItemIds], forKeys: [kOBJECTID as NSCopying, kEMAIL as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying, kFULLADDRESS as NSCopying, kONBOARD as NSCopying, kPURCHASEDITEMIDS as NSCopying])
}


//  MARK:- Update user

func updateCurrentUserInFirestore(withValues: [String : Any], complition: @escaping (_ error:Error?)-> Void){
    if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER){
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        
        FirebaseReference(.User).document(MUser.currentId()).updateData(withValues) { (error) in
            complition(error)
            
            if error == nil {
                saveUserLocally(mUserDictionary: userObject)
            }
        }
    }
}
