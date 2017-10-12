//
//  Item.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/8/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import Foundation
import UIKit

struct Item {
    
    var image = UIImage(named: "")
    var title = ""
    var assetIdentifier = ""
    
    init() { }
    
    init(image: UIImage, assetIdentifier: String, title: String) {
        self.image = image
        self.assetIdentifier = assetIdentifier
        self.title = title
    }
}
