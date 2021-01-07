//
//  Basket.swift
//  Market
//
//  Created by KurbanAli on 05/01/21.
//

import Foundation

class Basket {
    var id: String!
    var ownerID:String!
    var itemIds:[String]!
    
    init() {
        
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as? String
        ownerID = _dictionary[kOWNERID] as? String
        itemIds = _dictionary[kITEMIDS] as? [String]
    }
}
// MARK:- download items
func downloadBasketFromFirestore(_ ownerID: String, complition:@escaping(_ basket: Basket?)-> Void){
    FirebaseReference(.Basket).whereField(kOWNERID, isEqualTo: ownerID).getDocuments{ (snapshot, error) in
        guard let snapshot = snapshot else{
            complition(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0{
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            complition(basket)
        }else{
            complition(nil)
        }
    }
}

// MARK:- save to firebase
func saveBasketToFirestore(_ basket: Basket){
    
    FirebaseReference(.Basket).document(basket.id).setData(basketDictionaryFrom(basket) as! [String:Any])
    
}

//MARK:- Helper functions

func basketDictionaryFrom(_ basket: Basket) -> NSDictionary {
    
    return NSDictionary(objects: [basket.id, basket.ownerID, basket.itemIds] , forKeys: [kOBJECTID as NSCopying, kOWNERID as NSCopying, kITEMIDS as NSCopying])
}

//MARK:- upadte basket
func updateBasketInFirestore(_ basket: Basket, withValues: [String : Any], coplition:@escaping (_ error: Error?) -> Void){
    FirebaseReference(.Basket).document(basket.id).updateData(withValues) { (error) in
        coplition(error)
    }
}
