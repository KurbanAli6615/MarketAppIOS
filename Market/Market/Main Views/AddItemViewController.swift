//
//  AddItemViewController.swift
//  Market
//
//  Created by KurbanAli on 30/12/20.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {
    
    //    MARK:- IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //    MARK:- Vars
    var category: Category!
    var gallary:GalleryController!
    let hud = JGProgressHUD(style: .dark)
    
    var activityIndicator: NVActivityIndicatorView?
    
    var itemImages: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(category.id)
    }
    
    //    MARK:- IBActions
    
    
    @IBAction func doneBarButtonPressed(_ sender: Any) {
        dismissKeyboard()
        if checkFieldsAreCompleted(){
            saveToFirebase()
        }
        else{
            print("Fieds Are required")
            //            TODO: show error
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        itemImages = []
        showImageGallary()
    }
    
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    //    MARK:- Halper Functions
    
    private func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    private func checkFieldsAreCompleted()->Bool{
        return (titleTextField.text != "" && priceTextField.text != "" && descriptionTextView.text != "")
    }
    
    private func popTheView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //    MARK:- Save Items
    
    private func saveToFirebase(){
        let item = Item()
        item.id = UUID().uuidString
        item.name = titleTextField.text!
        item.categoryId = category.id
        item.description = descriptionTextView.text!
        item.price = Double(priceTextField.text!)
        
        if itemImages.count > 0{
            uploadImages(images: itemImages, itemId: item.id) { (imageLinksArray) in
                item.imageLinks = imageLinksArray
                
                saveItemToFirestore(item)
                self.popTheView()
            }
        } else{
            saveItemToFirestore(item)
            popTheView()
        }
    }
    
//    MARK: Show Gallary
    
    private func showImageGallary(){
        self.gallary = GalleryController()
        self.gallary.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallary, animated: true, completion: nil)
    }
}

extension AddItemViewController: GalleryControllerDelegate{
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0{
            Image.resolve(images: images) { (resolvedImages) in
                self.itemImages = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
