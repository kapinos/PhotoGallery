//
//  ManagerPhotos.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/12/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import Foundation

fileprivate let KeyTitles = "TitlesForPhotos"

class PhotosManager {
    
    static let sharedInstance = PhotosManager()
    
    private var dictionary = [String : String]()
    
    init() {
        if let titles = UserDefaults.standard.dictionary(forKey: KeyTitles) as? [String : String] {
            dictionary = titles
        }
    }
    
    func save() {
        UserDefaults.standard.set(dictionary, forKey: KeyTitles)
        UserDefaults.standard.synchronize()
    }
    
    func getTitle(by assetIdentifier: String) -> String {
        return dictionary[assetIdentifier] ?? ""
    }
    
    func setTitle(with assetIdentifier: String, title newTitle: String) {
        dictionary[assetIdentifier] = newTitle
    }
}
