//
//  ImageViewController.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/9/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit
import Photos

class ImageViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Properties
    var selectedAsset = PHAsset()
    var fetchResult = PHFetchResult<PHAsset>()
    var currentIndex = 0
    private var slides: [Slide] = []
    
    // MARK: IBOutlets
    @IBOutlet weak var pagesScrollView: UIScrollView! {
        didSet {
            pagesScrollView.delegate = self
            pagesScrollView.isPagingEnabled = true
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let count = fetchResult.count
        pagesScrollView.contentSize = CGSize(width: pagesScrollView.bounds.width * CGFloat(count), height: pagesScrollView.bounds.height)
        
        for _ in 0..<count {
            let slide = makeEmptySlide()
            slides.append(slide)
            pagesScrollView.addSubview(slide)
        }

        scrollViewReturnToPage(page: currentIndex)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pagesScrollView.contentSize = CGSize(width: pagesScrollView.bounds.width * CGFloat(fetchResult.count), height: pagesScrollView.bounds.height)
        
        for (index, slide) in slides.enumerated() {
            slide.frame = CGRect(x: pagesScrollView.bounds.width * CGFloat(index),
                                 y: 0,
                                 width:  pagesScrollView.bounds.width,
                                 height: pagesScrollView.bounds.height)
        }
        scrollViewReturnToPage(page: currentIndex)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        currentIndex = Int(round(pagesScrollView.contentOffset.x / view.frame.width))
    }
    
    // MARK: - Delegates
    
    // fetch current viewed image when scrolling with nearby images
    // shift for downloading images = 2
    private var currentPosition = -1
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        if position == currentPosition { return }
        currentPosition = position
        
        let shiftDownload = 2
        
        // set min/max borders for downloaded images
        let minIndex = max(0, position-shiftDownload)
        let maxIndex = min(position + shiftDownload, fetchResult.count-1)
        
        // - clear images goes beyond currentPosition ±shift
        // - if image in the currentPosition ±shift - fetch it
        for index in 0..<fetchResult.count {
            if index < minIndex || index > maxIndex {
                slides[index].item?.image = nil
            } else {
                fetchImage(at: index)
            }
        }
    }
    
   
    // MARK: - Inner Methods
    
    // init for creating slides for Array
    private func makeEmptySlide() -> Slide {
        return Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
    }
    
    // fetch definite image by index from asset from fetchResult
    func fetchImage(at index: Int) {
        guard slides[index].item?.image == nil else { return }
        
        let asset = fetchResult.object(at: index)
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        
        PHCachingImageManager.default().requestImage(for: asset,
                                                     targetSize: CGSize(width: 1920, height: 1080),
                                                     contentMode: .aspectFit,
                                                     options: options) { [weak self] (image, error) in
                                                        guard let itemImage = image else { return }
                                                        self?.slides[index].item = Item(image: itemImage, title: "\(index)")
        }
    }
    
    func scrollViewReturnToPage(page: Int) {
        var frame:CGRect = pagesScrollView.frame;
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        pagesScrollView.scrollRectToVisible(frame, animated: false)
    }
}












