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
        PHPhotoLibrary.shared().register(self)

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchResult = PHAsset.fetchAssets(with: fetchOptions)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clearsSelectionOnViewWillAppear = true
        self.navigationController?.hidesBarsOnTap = false
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

    
    // MARK: - Inner Methods

}


// MARK: PHPhotoLibraryChangeObserver

extension ItemsCollectionViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: fetchResult)
            else { return }
        
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            // new fetch result
            fetchResult = changes.fetchResultAfterChanges
            if changes.hasIncrementalChanges {
                // If we have incremental diffs, animate them in the collection view
                guard let collectionView = self.collectionView else { fatalError() }
                collectionView.performBatchUpdates({
                    // updates must be in this order:
                    // delete, insert, reload, move
                    if let removed = changes.removedIndexes, !removed.isEmpty {
                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let inserted = changes.insertedIndexes, !inserted.isEmpty {
                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                to: IndexPath(item: toIndex, section: 0))
                    }
                })
            } else {
                // Reload the collection view
                collectionView!.reloadData()
            }
        }
    }
}
