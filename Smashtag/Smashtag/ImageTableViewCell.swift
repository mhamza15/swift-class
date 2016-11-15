//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Mohamed Hamza on 7/23/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import UIKit
import Twitter

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetDetailsImageView: UIImageView!
    
    var tweetImage: UIImage? {
        get {
            return tweetDetailsImageView.image
        }
        set {
            tweetDetailsImageView.image = newValue
        }
    }
    
    var imageURL: NSURL? {
        didSet {
            if let url = imageURL {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [weak weakSelf = self] in
                    if let imageData = NSData(contentsOfURL: url) {
                        dispatch_async(dispatch_get_main_queue()) {
                            weakSelf?.tweetImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
