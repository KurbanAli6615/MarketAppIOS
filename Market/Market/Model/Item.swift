//
//  Item.swift
//  Market
//
//  Created by KurbanAli on 30/12/20.
//

import UIKit
import InstantSearchClient

class Item {
    
    var id: String!
    var categoryId: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    var isActive: Bool!
    
    init() {}
    
    init(_dictionary: NSDictionary) {
        
        id = _dictionary[kOBJECTID] as? String
        categoryId = _dictionary[kCATEGORYID] as? String
        name = _dictionary[kNAME] as? String
        description = _dictionary[kDESCRIPTION] as? String
        price = _dictionary[kPRICE] as? Double
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
        isActive = _dictionary[kISACTIVE] as? Bool
    }
}


//MARK:- Save items func

func saveItemToFirestore(_ item: Item) {
    
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String : Any])
}


//MARK:- Helper functions

func itemDictionaryFrom(_ item: Item) -> NSDictionary {
    
    return NSDictionary(objects: [item.id, item.categoryId, item.name, item.description, item.price, item.imageLinks, item.isActive], forKeys: [kOBJECTID as NSCopying, kCATEGORYID as NSCopying, kNAME as NSCopying, kDESCRIPTION as NSCopying, kPRICE as NSCopying, kIMAGELINKS as NSCopying, kISACTIVE as NSCopying])
}

//MARK:-    Download function

func downloadItemsFromFirebase(withCaegoryId: String, completion: @escaping(_ itemArray: [Item])-> Void){
    var itemArray: [Item] = []
    
    FirebaseReference(.Items).whereField(kCATEGORYID, isEqualTo: withCaegoryId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(itemArray)
            return
        }
        
        if !snapshot.isEmpty {
            for itemDict in snapshot.documents{
                itemArray.append(Item.init(_dictionary: itemDict.data() as NSDictionary))
            }
        }
        completion(itemArray)
    }
}

func downloadItems(_ withIDs: [String], complition: @escaping (_ itemArray: [Item])-> Void){
    var count = 0
    var itemArray: [Item] = []
    
    if withIDs.count > 0{
        
        for itemId in withIDs{
            FirebaseReference(.Items).document(itemId).getDocument { (snapshot, error) in
                guard let snapshot = snapshot else {
                    complition(itemArray)
                    return
                }
                if snapshot.exists {
                    
                    itemArray.append(Item(_dictionary: snapshot.data()! as NSDictionary))
                count += 1
                }else{
                    complition(itemArray)
                }
                
                if count == withIDs.count {
                    complition(itemArray)
                }
            }
        }
        
    }else{
        complition(itemArray)
    }
}

//  MARK:- Algolia func

func saveItemToAlgolia(item: Item) {
    
    let index = AlgoliaService.shared.index
    let itemToSave = itemDictionaryFrom(item) as! [String : Any]
    
    index.addObject(itemToSave, withID: item.id, requestOptions: nil) { (content, error) in
        
        if error != nil {
            print("Error in save to algolia ",error?.localizedDescription)
        }else{
            print("Added to algolia")
        }
    }
}

func searchAlgolia(searchString: String, complition: @escaping(_ itemArray: [String])-> Void) {
    
    let index = AlgoliaService.shared.index
    var resultIds: [String] = []
    
    let query = Query(query: searchString )
    
    query.attributesToRetrieve = ["name","description"]
    
    index.search(query) { (content, error) in
        if error == nil {
            let cont = content!["hits"] as! [[String : Any]]
            
            resultIds = []
            
            for result in cont{
                resultIds.append(result["objectID"] as! String )
            }
            
            complition(resultIds)
        } else {
            print("Error algolia search ",error!.localizedDescription)
            complition(resultIds)
        }
    }
}

