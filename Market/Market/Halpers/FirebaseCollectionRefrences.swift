//
//  FirebaseCollectionRefrences.swift
//  Market
//
//  Created by KurbanAli on 29/12/20.
//

import Foundation
import FirebaseFirestore

enum FCollectionRefrence: String{
    case User
    case Category
    case Items
    case Basket
}

func FirebaseRefrence(_ collectionRefence: FCollectionRefrence) -> CollectionReference{
    return Firestore.firestore().collection(collectionRefence.rawValue)
}
