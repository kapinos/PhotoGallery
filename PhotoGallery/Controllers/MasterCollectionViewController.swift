//
//  ItemCollectionViewController.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/8/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import AlamofireImage

private let reuseIdentifier = "ItemCell"

class MasterCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    var fetchResult = PHFetchResult<PHAsset>()
    var selectedPhotosForUpload: [Photo] = []
    private let customNavigationAnimationController = CustomNavigationAnimationController()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.collectionView?.alwaysBounceVertical = true
        self.configureNavigationController()
        
        PHPhotoLibrary.shared().register(self)
        
        // caching images
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
        
        collectionView?.reloadData()
        self.navigationController?.toolbar.isHidden = true
//        scrollCollectionToBottom()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.toolbar.isHidden = false
    }

    // MARK: - UI Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Input tag for searching photos", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Find", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first, let tag = textField.text else { return }
            self.performSegue(withIdentifier: "downloadPhotosByTag", sender: tag)
        }
        alert.addTextField { (textField : UITextField!) -> Void in textField.placeholder = "Add a tag" }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) in }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
        scrollCollectionToBottom()
    }
    
    @IBAction func buttonCameraPressed(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker: UIImagePickerController = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = false
            self.present(picker, animated: true, completion: nil)
            
        } else {
            // no camera
            let alertController = UIAlertController(title: "Error", message: "No camera is available. Use it on device", preferredStyle: .alert)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MasterCollectionViewCell
        
        let asset = fetchResult.object(at: indexPath.item)
        cell.assetIdentifier = asset.localIdentifier
        
        // fetch images and thier titles
        PHCachingImageManager.default().requestImage(for: asset, targetSize: IMAGE_SIZE_FOR_FETCHING, contentMode: .aspectFill, options: nil) { (image, error) in
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
        picker.dismiss(animated: true) {
            self.scrollCollectionToBottom()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Navigation
    
    @IBAction func unwindSegueToMasterVC(_ sender: UIStoryboardSegue) {
        if let source = sender.source as? DownloadedItemsCollectionViewController {
            selectedPhotosForUpload = source.selectedPhotos
            for photo in selectedPhotosForUpload {
                fetchPhoto(url: photo.webformatURL)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showItemDetail":
                if let indexPaths = collectionView?.indexPathsForSelectedItems {
                    // configure the view controller with the itemsSet
                    let destinationController = segue.destination as! ImageViewController
                    let asset = fetchResult.object(at: indexPaths.first?.row ?? 0)
                    
                    destinationController.selectedAsset = asset
                    destinationController.fetchResult = fetchResult
                    destinationController.currentIndex = indexPaths.first?.row ?? 0
                }
            case "downloadPhotosByTag":
                let secondViewController = segue.destination as? DownloadedItemsCollectionViewController
                if let svc = secondViewController, let tag = sender as? String {
                    svc.tagForSearchingPhoto = tag
                }
            default: break
            }
        }
    }

    
    // MARK: - Inner Methods
    
    private func configureNavigationController()  {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.delegate = self
        self.navigationController?.toolbar.isHidden = true
    }
    
    private func scrollCollectionToBottom() {
        guard let sectionsCount = collectionView?.numberOfSections, sectionsCount > 0 else { return }
        guard let itemsCount = collectionView?.numberOfItems(inSection: sectionsCount - 1), itemsCount > 0 else { return }
        
        let indexPath = IndexPath(item: itemsCount - 1, section: sectionsCount - 1)
        collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    private func fetchPhoto(url: String) {
        
        Alamofire.request(url).responseImage { response in
            //            debugPrint(response)
            //            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { (success:Bool, error:Error?) in
                    if success {
                        print("Image Saved Successfully")
                        self.scrollCollectionToBottom()
                    } else {
                        print("Error in saving:"+error.debugDescription)
                    }
                }
            }
        }
    }
    
    // MARK: - Animation
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        customNavigationAnimationController.reverse = operation == .pop
        return customNavigationAnimationController
    }
}


// MARK: PHPhotoLibraryChangeObserver

extension MasterCollectionViewController: PHPhotoLibraryChangeObserver {
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
