//
//  Slide.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/9/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit

class Slide: UIView {

    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.01
            scrollView.maximumZoomScale = 4
            scrollView.addSubview(imageView)
        }
    }
    
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
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.contentSize = scrollView.bounds.size
        
        let widthRatio = scrollView.bounds.size.width / imageView.bounds.size.width
        let heightRatio = scrollView.bounds.size.height / imageView.bounds.size.height
        
        scrollView.zoomScale = min(widthRatio, heightRatio)
        scrollView.contentInset = UIEdgeInsets(top: (scrollView.bounds.size.height - imageView.frame.size.height) / 2,
                                               left: (scrollView.bounds.size.width - imageView.frame.size.width) / 2,
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

