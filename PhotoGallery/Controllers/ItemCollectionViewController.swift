//
//  ItemCollectionViewController.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/8/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ItemCell"

class ItemCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
       // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    private var itemsSet: [Item]!
    
    private func initItems()  {
        itemsSet = [
            Item(name: "monster1", title: "monster1"),
            Item(name: "monster2", title: "monster2"),
            Item(name: "monster3", title: "monster3"),
            Item(name: "monster4", title: "monster4"),
            Item(name: "monster5", title: "monster5"),
            Item(name: "monster6", title: "monster6"),
            Item(name: "monster7", title: "monster7"),
            Item(name: "monster8", title: "monster8"),
            Item(name: "monster9", title: "monster9"),
            Item(name: "monster10", title: "monster10"),
            Item(name: "monster11", title: "monster11"),
            Item(name: "monster12", title: "monster12"),
            Item(name: "monster13", title: "monster13")
        ]
    }

    
    // MARK: - Navigation
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItemDetail" {
            if let indexPaths = collectionView?.indexPathsForSelectedItems {
                let destinationController = segue.destination as! ImageViewController
                destinationController.currentPage = indexPaths[0].row
                destinationController.items = itemsSet
                
                
                collectionView?.deselectItem(at: indexPaths[0], animated: true)
            }
        }
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
        cell.configureCell(imageName: item.name, titleText: item.title)
        
        return cell
    }

    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) != nil {
            let item = itemsSet[indexPath.row]
            itemsSet[indexPath.row].isFeatured = !item.isFeatured
           // cell.backgroundView = (itemsSet[indexPath.row].isFeatured) ? UIImageView(image: UIImage(named: "feature-bg")) : UIImageView(image: UIImage(named: ""))
        }
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

    // MARK:
    
}
