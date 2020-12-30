//
//  Item.swift
//  Market
//
//  Created by KurbanAli on 30/12/20.
//

import Foundation
import UIKit

class Item {
    
    var id: String!
    var categoryID: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    
    init (){
        
    }
    
    init(_dictionary: NSDictionary){
        id = _dictionary[kOBJECTID] as? String
        categoryID = _dictionary[kCATEGORYID] as? String
        name = _dictionary[kNAME] as? String
        description = _dictionary[kDESCRIPTION] as? String
        price = _dictionary[kPRICE] as? Double
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
    }
    
}


// MARK:- Save Items to firebase

func saveItemsToFireStore(_ item: Item){
    FirebaseRefrence(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String : Any])
}


// MARK:- Halper Functions
func itemDictionaryFrom(_ items: Item) -> NSDictionary{
    return NSDictionary(object: [items.id, items.categoryID , items.name, items.description, items.price, items.imageLinks], forKey: [kOBJECTID as NSCopying, kCATEGORYID as NSCopying, kNAME as NSCopying, kDESCRIPTION as NSCopying, kDESCRIPTION as NSCopying, kPRICE as NSCopying, kIMAGELINKS as NSCopying] as NSCopying)
}
