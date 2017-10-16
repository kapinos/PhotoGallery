//
//  Photos.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/16/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import Foundation
import Alamofire

class Photos {
    var collection:[Photo] = []
    
    func downloadPhotos(tag: String, completed: @escaping () -> ()) {
        // Alamofire
        let editedTag = tag.replacingOccurrences(of: " ", with: "+")
        let defaultImagesURL = URL(string: DEFAULT_IMAGES_SEARCH + editedTag)
        Alamofire.request(defaultImagesURL!).responseJSON { response in
            if response.error != nil {
                print("ERROR: \(String(describing: response.error?.localizedDescription))")
                return
            }
            
            let result = response.result
            
            guard let dict = result.value as? Dictionary<String, Any>  else { return }
            guard let hits = dict["hits"] as? [Dictionary<String, Any>]  else { return }
            
            for object in hits {
                let id = object["id"] as! Int
                let previewURL = object["previewURL"] as! String
                let webformatURL = object["webformatURL"] as! String
                //print("id: \(id); url: \(webformatURL)")
                let photo = Photo(id, previewURL, webformatURL)
                self.collection.append(photo)
            }
            completed()
        }
    }
}
