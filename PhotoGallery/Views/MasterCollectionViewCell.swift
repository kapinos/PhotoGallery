//
//  MasterCollectionViewCell.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/8/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit

class MasterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var grayView: UIView!
    
    public private(set) var itemForCell = Item()

    var assetIdentifier: String = ""
    
    func configureCell(by item: Item) {
        
        self.itemForCell = item
        
        grayView.isHidden = item.title.isEmpty
        
        imageView.image = itemForCell.image
        titleLable.text = itemForCell.title
        
        // sublayers of the layer that extend outside its boundaries clipped to those boundaries
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
    }
    
    func clearItem() {
        self.itemForCell.title = ""
    }
}

