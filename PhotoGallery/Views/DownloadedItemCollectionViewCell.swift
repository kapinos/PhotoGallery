//
//  DownloadedItemCollectionViewCell.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/16/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit

class DownloadedItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = 3.0
            self.layer.borderColor = isSelected ? COLOUR_SELECTED_PHOTO.cgColor : UIColor.clear.cgColor
        }
    }
    
    func configureCell(image: UIImage) {
        self.imageView.image = image
    }
}
