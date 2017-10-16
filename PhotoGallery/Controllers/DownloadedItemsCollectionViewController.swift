//
//  DownloadedItemsCollectionViewController.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/16/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

private let reuseIdentifier = "ItemCell"

class DownloadedItemsCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    var tagForSearchingPhoto = ""
    private var photos = Photos()
    @IBOutlet private weak var actionDownloadPhotos: UIBarButtonItem!
    
    // collection of selected photos for downloading to Gallery
    var selectedPhotos: [Photo] = [] {
        didSet {
            // if collection of selected photos not empty - available upload photos, barButton appear
            let text = (selectedPhotos.isEmpty ? "" : "\(selectedPhotos.count) selected")
            let item = UIBarButtonItem(title: text, style: .plain, target: self, action: nil)
            item.customView?.isUserInteractionEnabled = false
            navigationItem.rightBarButtonItem = item
            
            shouldHideActionItem(text.isEmpty)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.collectionView?.allowsMultipleSelection = true
        
        shouldHideActionItem(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = tagForSearchingPhoto
        
        photos.downloadPhotos(tag: tagForSearchingPhoto) {
            self.collectionView?.reloadData()
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.collection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DownloadedItemCollectionViewCell
        
        let url = photos.collection[indexPath.item].previewURL
        Alamofire.request(url).responseImage { response in
            //debugPrint(response)
            //debugPrint(response.result)
            
            if let image = response.result.value {
                cell.configureCell(image: image)
            }
        }
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if !selectedItems.contains(indexPath) {
                let photo = photos.collection[indexPath.item]
                selectedPhotos.append(photo)
            }
        }
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
                let photo = photos.collection[indexPath.item]
                selectedPhotos = selectedPhotos.filter{ $0.id != photo.id }
                return false
            }
        }
        return true
    }
    
    // MARK: - UI Actions
    
    @IBAction func buttonDownloadPhotosPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindSegueToMasterViewController", sender: selectedPhotos)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindSegueToMasterViewController" {
            if let destination = segue.destination as? MasterCollectionViewController {
                if let photosForUpload = sender as? [Photo] {
                    destination.selectedPhotosForUpload = photosForUpload
                }
            }
        }
    }
    
    // MARK: - Inner Methods
    private func shouldHideActionItem(_ hide: Bool)  {
        //actionUploadPhotos.tintColor = hide ? UIColor.clear : UIColor.blue
        actionDownloadPhotos.isEnabled = !hide
    }
}
