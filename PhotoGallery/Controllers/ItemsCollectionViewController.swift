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

class ItemsCollectionViewController: UICollectionViewController {

    // MARK: - Properties
    var assetCollection = PHAssetCollection()
    var assets = PHFetchResult<PHAsset>()
    private var itemsSet: [Item]!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        assets = PHAsset.fetchAssets(with: fetchOptions)
        
        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // FIXME: OBSERVER
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clearsSelectionOnViewWillAppear = true
        self.navigationController?.hidesBarsOnTap = false
        
        // fetch images from assets // FIXME: fetch titles
        itemsSet = getItemsFromAssets()
        collectionView?.reloadData()
    }

    
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsSet.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
    
        let item = itemsSet[indexPath.row]
        // FIXME: optional image
        cell.configureCell(image: item.image!, title: item.title)
        
        return cell
    }

    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) != nil {
            let item = itemsSet[indexPath.row]
        }
    }
    
    
    // MARK: - Navigation
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItemDetail" {
            if let indexPaths = collectionView?.indexPathsForSelectedItems {
                // configure the view controller with the itemsSet
                let destinationController = segue.destination as! ImageViewController
                destinationController.currentPage = indexPaths[0].row
                destinationController.items = itemsSet
            }
        }
    }
    
    
    // MARK: - Inner Methods
    
    // fetch images in items from assets
    private func getItemsFromAssets() -> [Item] {
        var items: [Item] = []
        for i in 0..<min(10_000, assets.count) {
            let asset = assets[i] as PHAsset
            // FIXME: set size fetched image
            PHImageManager.default().requestImage(for: asset,
                                                  targetSize: CGSize(width: 250.0, height: 250.0),
                                                  contentMode: .aspectFill,
                                                  options: nil,
                                                  resultHandler: { (result, info) in
                                                    items.append(Item(image: result!, title: "title"))
            })
        }
        return items
    }
    
    
    
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
