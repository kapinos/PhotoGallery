//
//  Item.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/8/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import Foundation

struct Item {
    var name: String = ""
    var title: String = ""
    var isFeatured = false
    
    init(name: String, title: String, isFeatured: Bool = false) {
        self.name = name
        self.title = title
        self.isFeatured = isFeatured
    }
}
