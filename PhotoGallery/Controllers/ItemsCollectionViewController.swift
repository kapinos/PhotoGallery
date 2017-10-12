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
private let imageSizeForFetching = CGSize(width: 512, height: 512)

class ItemsCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    //var assetCollection = PHAssetCollection()
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
        
        //UserDefaults.standard.removeObject(forKey: "TitlesForPhotos")
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clearsSelectionOnViewWillAppear = true
        self.navigationController?.hidesBarsOnTap = false
        
        collectionView?.reloadData()
    }

    // MARK: - UI Actions
    
    @IBAction func buttonCameraPressed(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker: UIImagePickerController = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
            
        } else {
            // no camera
            let alertController = UIAlertController(title: "Error", message: "No camera is available", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) {
                (result: UIAlertAction) in alertController.dismiss(animated: true, completion: nil)
            })
            self.present(alertController, animated: true, completion: nil)
        }
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
        
        // fetch images and thier titles
        imageManager.requestImage(for: asset,
                                  targetSize: imageSizeForFetching,
                                  contentMode: .aspectFill,
                                  options: nil) { (image, error) in
                                    if cell.assetIdentifier == asset.localIdentifier && image != nil {
                                        let title = PhotosManager.sharedInstance.getTitle(by: asset.localIdentifier)
                                        let item = Item(image: image!, assetIdentifier: asset.localIdentifier, title: title)
                                        cell.configureCell(by: item)
                                    }
        }
        return cell
    }
    
    
    // MARK : - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if success {
                print("Successfully added")
            } else {
                print("can't add asset: \(String(describing: error))")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
    private func scrollCollectionToBottom() {
        let lastSectionIndex = (collectionView?.numberOfSections ?? 1) - 1
        let lastItemIndex = (collectionView?.numberOfItems(inSection: lastSectionIndex) ?? 1) - 1
        let indexPath = IndexPath(item: lastItemIndex, section: lastSectionIndex)
        
        collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
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
