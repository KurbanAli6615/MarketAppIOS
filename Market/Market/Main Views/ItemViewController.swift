//
//  ItemViewController.swift
//  Market
//
//  Created by KurbanAli on 31/12/20.
//

import UIKit
import JGProgressHUD


class ItemViewController: UIViewController {

//    MARK:- IBOutlets
    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
//    MARK:- Vars
    
    var item: Item!
    var itemImages: [UIImage] = []
    let hud = JGProgressHUD(style: .dark)
    
    private let cellheight: CGFloat = 196.0
    private let itemsPerRow:CGFloat = 1
    
//    MARK:- ViewLife cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        downloadPictures()
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backAction))]
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "basket"), style: .plain, target: self, action: #selector(self.addToBasketButtonPressed))]
    }
    
    //    MARK:- Download Pictures
  
    private func downloadPictures(){
        if item != nil && item.imageLinks != nil {
            downloadImages(imageUrls: item.imageLinks) { (allImages) in
                if allImages.count > 0{
                    self.itemImages = allImages as! [UIImage]
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }
    
    //    MARK:- Setup UI

    private func setupUI(){
        if item != nil{
            self.title = item.name
            nameLabel.text = item.name
            priceLabel.text = convertToCurrency(item.price)
            descriptionTextView.text = item.description
        }
    }
    
    //    MARK:- IBActions
    @objc func backAction (){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addToBasketButtonPressed(){
        print("add to basket", item.name)
    }
}


extension ItemViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1 : itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        if itemImages.count > 0 {
            cell.setupImageWith(itemImage: itemImages[indexPath.row])
        }
        return cell
    }
}

extension ItemViewController: UICollectionViewDelegateFlowLayout{
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//
//        let avalibleWidth = collectionView.frame.width - sectionInsets.left
//
//        print(avalibleWidth)
//        return CGSize(width: avalibleWidth, height: cellheight)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let imgWidth = view.bounds.width 

        return CGSize(width: imgWidth, height: cellheight)
    }
}
