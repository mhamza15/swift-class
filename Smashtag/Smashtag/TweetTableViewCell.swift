//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Mohamed Hamza on 7/19/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!

    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        // reset any existing tweet info
        
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new info
        
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [weak weakSelf = self] in
                    if let imageData = NSData(contentsOfURL: profileImageURL) {
                        dispatch_async(dispatch_get_main_queue()) {
                            weakSelf?.tweetProfileImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
            
            let mutAttString = tweetTextLabel.attributedText as? NSMutableAttributedString

            
            for hashtag in tweet.hashtags {
                mutAttString?.setAttributes([NSForegroundColorAttributeName : UIColor.purpleColor()], range: hashtag.nsrange)
            }
            for url in tweet.urls {
                mutAttString?.setAttributes([NSForegroundColorAttributeName : UIColor.blueColor()], range: url.nsrange)
            }
            for userMention in tweet.userMentions {
                mutAttString?.setAttributes([NSForegroundColorAttributeName : UIColor.brownColor()], range: userMention.nsrange)
            }
        }
        
        
    }
}
