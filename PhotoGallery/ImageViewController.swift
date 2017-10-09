//
//  ImageViewController.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/9/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.01
            scrollView.maximumZoomScale = 4
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    // MARK: - Properties
    var item: Item? {
        didSet {
            if let item = item {
                image = UIImage(named: item.name)
            }
        }
    }
    
/*
      // !!!!!
    // get by selected image in UICollectionView
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
*/
    
    fileprivate var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
            autoZoomed = true
            scaleToFitImage()
        }
    }
    
    // MARK: - Inner Methods
/*
     // !!!!!
    private func fetchImage() {
        if let url = imageURL {
            spinner.startAnimating()
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            })
            task.resume()
        }
    }
 */
 
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
      // !!!!!
        if image == nil {
            fetchImage()
        }
 */
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scaleToFitImage()
    }
    
    
    // MARK: - Set Autozooming For Image
    
    fileprivate var autoZoomed = true
    private func scaleToFitImage() {
        if !autoZoomed {
            return
        }
        
        guard let scrollView = scrollView,
            image != nil && (imageView.bounds.size.width > 0) && (scrollView.bounds.size.width > 0) else { return }
        
        let widthRatio = scrollView.bounds.size.width / imageView.bounds.size.width
        let heightRatio = scrollView.bounds.size.height / imageView.bounds.size.height
        
        scrollView.zoomScale = (widthRatio > heightRatio) ? widthRatio : heightRatio
        scrollView.contentOffset = CGPoint(x: (imageView.frame.size.width - scrollView.frame.size.width) / 2,
                                           y:  (imageView.frame.size.height - scrollView.frame.size.height) / 2)
        
    }
}

extension ImageViewController: UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // unable autoFit after user begin pinching image
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        autoZoomed = false
    }
}
