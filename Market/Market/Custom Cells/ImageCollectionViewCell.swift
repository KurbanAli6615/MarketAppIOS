//
//  ImageCollectionViewCell.swift
//  Market
//
//  Created by KurbanAli on 31/12/20.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage){
        imageView.image = itemImage
    }
}
