//
//  Slide.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/9/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit

class Slide: UIView {

    // MARK: - Properties
    
    var item: Item? {
        didSet {
            guard let item = item else { return }
            image = item.image
        }
    }
    
    fileprivate var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            updateLayouts()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var zoomingScrollView: UIScrollView! {
        didSet {
            zoomingScrollView.delegate = self
            zoomingScrollView.minimumZoomScale = 0.01
            zoomingScrollView.maximumZoomScale = 4
            zoomingScrollView.addSubview(imageView)
        }
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayouts()
    }
    
    // MARK: - Update Layouts for slides content
    func updateLayouts() {
        guard image != nil else { return }
        
        zoomingScrollView.contentSize = zoomingScrollView.bounds.size
        
        let widthRatio = zoomingScrollView.bounds.size.width / imageView.bounds.size.width
        let heightRatio = zoomingScrollView.bounds.size.height / imageView.bounds.size.height
        
        zoomingScrollView.zoomScale = min(widthRatio, heightRatio)
        zoomingScrollView.contentInset = UIEdgeInsets(top: (zoomingScrollView.bounds.size.height - imageView.frame.size.height) / 2,
                                                      left: (zoomingScrollView.bounds.size.width - imageView.frame.size.width) / 2,
                                                      bottom: 0, right: 0)
    }
}

extension Slide: UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.contentInset = UIEdgeInsets(top: (scrollView.bounds.size.height - imageView.frame.size.height) / 2,
                                               left: (scrollView.bounds.size.width - imageView.frame.size.width) / 2,
                                               bottom: 0, right: 0)
    }
}

