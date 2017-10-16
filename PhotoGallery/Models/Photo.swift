//
//  Photo.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/16/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import Foundation

struct Photo {
    
    let id: Int
    let previewURL: String
    let webformatURL: String
    
    init(_ id: Int, _ previewURL: String, _ webformatURL: String) {
        self.id = id
        self.previewURL = previewURL
        self.webformatURL = webformatURL
    }
}
