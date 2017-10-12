//
//  ItemCollectionViewCell.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/8/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLable: UILabel!
    
    var assetIdentifier: String = ""
    
    func configureCell(by item: Item) {
        imageView.image = item.image
        titleLable.text = item.title
        
        // sublayers of the layer that extend outside its boundaries clipped to those boundaries
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
    }
}

