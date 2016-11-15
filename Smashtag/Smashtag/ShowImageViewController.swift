//
//  ShowImageViewController.swift
//  Smashtag
//
//  Created by Mohamed Hamza on 7/23/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController, UIScrollViewDelegate {
    
    var tweetImage: UIImage? {
        get {
            return mediaImageView.image
        }
        set {
            mediaImageView.image = newValue
            mediaImageView.sizeToFit()
        }
    }
    
    @IBOutlet weak var imageScrollView: UIScrollView! {
        didSet {
            if let imageSize = tweetImage?.size {
                imageScrollView.contentSize = imageSize
            }
            imageScrollView.delegate = self
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return mediaImageView
    }
    
    private var mediaImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView.addSubview(mediaImageView)
        mediaImageView.sizeToFit()
    }
    
}
