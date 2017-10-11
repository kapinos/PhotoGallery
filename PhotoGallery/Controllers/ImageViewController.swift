//
//  ImageViewController.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/9/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollViewPages: UIScrollView! {
        didSet {
            scrollViewPages.delegate = self
            scrollViewPages.isPagingEnabled = true
        }
    }
    
    // MARK: - Properties
    
    var currentPage = 0
    var items = [Item]()
    private var slides = [Slide]()

    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        slides = createSlides()
        for slide in slides {
            scrollViewPages.addSubview(slide)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollViewPages.contentSize = CGSize(width: scrollViewPages.bounds.width * CGFloat(slides.count), height: scrollViewPages.bounds.height)
        for (index, slide) in slides.enumerated() {
            slide.frame = CGRect(x: scrollViewPages.bounds.width * CGFloat(index),
                                 y: 0,
                                 width:  scrollViewPages.bounds.width,
                                 height: scrollViewPages.bounds.height)
        }
        scrollViewReturnToPage(page: currentPage)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        currentPage = Int(round(scrollViewPages.contentOffset.x / view.frame.width))
    }
    
    // MARK: - Delegates
    
   
    // MARK: - Inner Methods
    
    func createSlides() -> [Slide] {
        var slidesArray = [Slide]()
        for item in items {
            let slide: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            slide.item = item
            slidesArray.append(slide)
        }
        return slidesArray
    }
    
    func scrollViewReturnToPage(page: Int) {
        var frame:CGRect = scrollViewPages.frame;
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        scrollViewPages.scrollRectToVisible(frame, animated: false)
    }
}
