//
//  AlgoliyaService.swift
//  Market
//
//  Created by KurbanAli on 11/01/21.
//

import Foundation
import InstantSearchClient

class AlgoliyaServie {
    
    static let shared = AlgoliyaServie()
    
    let client = Client(appID: kALGOLIA_APP_ID, apiKey: kALGOLIA_ADMIN_KEY)
    let index = Client(appID: kALGOLIA_APP_ID, apiKey: kALGOLIA_ADMIN_KEY).index(withName: "item_name")
    
    private init() {}
    
}
