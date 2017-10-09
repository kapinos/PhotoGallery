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
    
    func configureCell(imageName: String, titleText: String) {
        imageView.image = UIImage(named: imageName)
        titleLable.text = titleText
    }
}
