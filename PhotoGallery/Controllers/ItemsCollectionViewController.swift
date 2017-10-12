//
//  ItemCollectionViewController.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/8/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "ItemCell"
private let imageSizeForFetching = CGSize(width: 1024, height: 1024)

class ItemsCollectionViewController: UICollectionViewController {

    // MARK: - Properties
    var assetCollection = PHAssetCollection()
    var fetchResult = PHFetchResult<PHAsset>()

    // TODO: itemsSet
    private var imageManager = PHCachingImageManager()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchResult = PHAsset.fetchAssets(with: fetchOptions)

        // FIXME: OBSERVER
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clearsSelectionOnViewWillAppear = true
        self.navigationController?.hidesBarsOnTap = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: updateCashedAssets
    }
    
    // MARK: - UICollectionViewDataSource & UICollectionViewDelegate

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
    
        let asset = fetchResult.object(at: indexPath.item)
        cell.assetIdentifier = asset.localIdentifier
        // TODO: fetch titles
        imageManager.requestImage(for: asset,
                                targetSize: imageSizeForFetching,
                                contentMode: .aspectFill,
                                options: nil) { (image, error) in
                                    if cell.assetIdentifier == asset.localIdentifier && image != nil {
                                        cell.configureCell(image: image!, title: asset.localIdentifier)
                                    }
        }
        return cell
    }
    
    // MARK: - UI Actions
    
    @IBAction func buttonCameraPressed(_ sender: UIBarButtonItem) {
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItemDetail" {
            if let indexPaths = collectionView?.indexPathsForSelectedItems {
                // configure the view controller with the itemsSet
                let destinationController = segue.destination as! ImageViewController
                let asset = fetchResult.object(at: indexPaths.first?.row ?? 0)
                
                destinationController.selectedAsset = asset
                destinationController.fetchResult = fetchResult
                destinationController.currentIndex = indexPaths.first?.row ?? 0
            }
        }
    }
    // TODO: - Caching Asset images
    // ll: 148 - AssetGridVC
    
    
    // MARK: - Inner Methods
    
    
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}
