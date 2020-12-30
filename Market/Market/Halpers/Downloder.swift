//
//  Downloder.swift
//  Market
//
//  Created by KurbanAli on 30/12/20.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage()

func uploadImages(images: [UIImage?], itemId: String, completion: @escaping (_ imageLinks: [String])-> Void){
    
    if Reachabilty.HasConnection(){
        
        var uploadedImagesCount = 0
        var imageLinkArray: [String] = []
        var nameSuffix = 0
        
        for image in images{
            let fileName = "ItemImages/" + itemId + "/\(nameSuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.5)
            
            saveImageInFirebase(imageData: imageData!, fileName: fileName) { (imageLink) in
                if imageLink != nil {
                    imageLinkArray.append(imageLink!)
                    
                    uploadedImagesCount += 1
                    
                    if uploadedImagesCount == images.count{
                        completion(imageLinkArray)
                    }
                }
            }
            nameSuffix += 1
        }
        
    }else{
        print("No Connection Found")
    }
    
}

func saveImageInFirebase(imageData: Data, fileName: String, complition: @escaping (_ imageLink: String?) -> Void){
    
    var task: StorageUploadTask!
    
    let storegeRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)
    
    task = storegeRef.putData(imageData, metadata: nil, completion: { (metaData, error) in
        
        task.removeAllObservers()
        
        if error != nil {
            print("Error Uploading Images ", error!.localizedDescription)
            complition(nil)
            return
        }
        
        storegeRef.downloadURL { (url, error) in
            
            guard let downloadUrl = url  else{
                complition(nil)
                return
            }
            complition(downloadUrl.absoluteString)
        }
    })
}
