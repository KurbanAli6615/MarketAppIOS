//
//  CategoryCollectionViewController.swift
//  Market
//
//  Created by KurbanAli on 29/12/20.
//

import UIKit

class CategoryCollectionViewController: UICollectionViewController {

//    MARK:- Vars
    var categoryArray: [Category] = []
    
  
    private let sectionInsets =  UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    private let itemsPerRow:CGFloat = 3
    
//    MARK:- View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
          
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCategories()
    }


    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         
        return categoryArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
    
        cell.generateCell(categoryArray[indexPath.row])
        return cell
    }

//    MARK:- Download Categories
    private func loadCategories(){
        downloadCategoriesFromFirebase { (allCategories) in
            print("we have ", allCategories.count)
            self.categoryArray = allCategories
            self.collectionView.reloadData()
        }
    }
}

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1 )
        let avalibleWidth = view.frame.width - paddingSpace
        let widthPerItem = avalibleWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
