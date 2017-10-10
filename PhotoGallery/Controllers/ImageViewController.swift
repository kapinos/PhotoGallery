//
//  ImageViewController.swift
//  PhotoGallery
//
//  Created by Anastasia on 10/9/17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.isPagingEnabled = true
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
            scrollView.addSubview(slide)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(slides.count), height: scrollView.bounds.height)
        for (index, slide) in slides.enumerated() {
            slide.frame = CGRect(x: scrollView.bounds.width * CGFloat(index),
                                 y: 0,
                                 width:  scrollView.bounds.width,
                                 height: scrollView.bounds.height)
        }
        scrollViewReturnToPage(page: currentPage)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        currentPage = Int(round(scrollView.contentOffset.x / view.frame.width))
    }
    
    // MARK: - Delegates
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //let pageIndex = Int(round(scrollView.contentOffset.x / view.frame.width))
        // FIX ME-CHECK idx
       // let slide = slides[pageIndex]
    }
    
   
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
        var frame:CGRect = scrollView.frame;
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        scrollView.scrollRectToVisible(frame, animated: false)
    }
}
