//
//  ItemCollectionViewCell.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/8/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    
    func configureCell(image: UIImage, title: String) {
        imageView.image = image
        titleLable.text = title
        
        // sublayers of the layer that extend outside its boundaries clipped to those boundaries
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
    }
}

