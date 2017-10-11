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

    
    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
}
