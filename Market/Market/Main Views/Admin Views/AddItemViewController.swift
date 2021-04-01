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
    
    //    MARK:- View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(category.id)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulseSync, color: #colorLiteral(red: 0.9998469949, green: 0.4941213727, blue: 0.4734867811, alpha: 1), padding: nil)
    }
    
    //    MARK:- IBActions
    
    
    @IBAction func doneBarButtonPressed(_ sender: Any) {
        dismissKeyboard()
        if checkFieldsAreCompleted(){
            saveToFirebase()
        }
        else{
//            print("Fieds Are required")
            self.hud.textLabel.text = "All Fields Are required"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.5)
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
        
        showLoadingIndicator()
        
        let item = Item()
        item.id = UUID().uuidString
        item.name = titleTextField.text!
        item.categoryId = category.id
        item.description = descriptionTextView.text!
        item.price = Double(priceTextField.text!)
        item.isActive = true
        
        if itemImages.count > 0{
            uploadImages(images: itemImages, itemId: item.id) { (imageLinksArray) in
                item.imageLinks = imageLinksArray
                
                saveItemToFirestore(item)
                saveItemToAlgolia(item: item)
                
                self.hideLoadingIndicator()
                self.popTheView()
            }
        } else{
            saveItemToFirestore(item)
            saveItemToAlgolia(item: item)
            popTheView()
        }
    }
    
//    MARK: Activity Indicator
    
    private func showLoadingIndicator(){
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator(){
        if activityIndicator != nil {
            activityIndicator?.removeFromSuperview()
            activityIndicator!.stopAnimating()
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
