//
//  TweetDetailsTableViewController.swift
//  Smashtag
//
//  Created by Mohamed Hamza on 7/22/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailsTableViewController: UITableViewController {
    
    var tweet: Twitter.Tweet?
    
    var mentionsSizes: [Int]? {
        get {
            if tweet != nil {
                return [tweet!.media.count, tweet!.hashtags.count, tweet!.userMentions.count, tweet!.urls.count]
            } else {
                return nil
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.bounds.width / CGFloat((tweet?.media[indexPath.row].aspectRatio)!)
        }
        return -1
    }
    
    var sectionNames: [String?]? {
        get {
            if tweet != nil {
                
                return [(tweet?.media.count != 0) ? "Media" : nil, (tweet?.hashtags.count != 0) ? "Hashtags" : nil, (tweet?.userMentions.count != 0) ? "Users" : nil, (tweet?.urls.count != 0) ? "URLs" : nil]
            } else { return nil }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    struct Storyboard {
        static let ImageCellIdentifier = "ImageCell"
        static let NotImageCellIdentifier = "NotImageCell"
        static let URLCellIdentifier = "URLCell"
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames?[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.section {
        case 0: // Media
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellIdentifier, forIndexPath: indexPath)
            if let mediaCell = cell as? ImageTableViewCell {
                mediaCell.imageURL = tweet?.media[indexPath.row].url
                mediaCell.setNeedsLayout()
                mediaCell.layoutIfNeeded()
                return mediaCell
            }
        case 1: // Hashtags
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.NotImageCellIdentifier, forIndexPath: indexPath)
            cell.textLabel?.text = tweet?.hashtags[indexPath.row].keyword
            return cell
        case 2: // Users
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.NotImageCellIdentifier, forIndexPath: indexPath)
            cell.textLabel?.text = tweet?.userMentions[indexPath.row].keyword
            return cell
        case 3: // URLs
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.URLCellIdentifier, forIndexPath: indexPath)
            cell.textLabel?.text = tweet?.urls[indexPath.row].keyword
            return cell
        default:
            break
        }
        return cell
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mentionsSizes?[section] ?? 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage" {
            if let showImageVC = segue.destinationViewController as? ShowImageViewController {
                if let cell = sender as? ImageTableViewCell {
                    showImageVC.tweetImage = cell.tweetImage
                }
            }
        }
        else if segue.identifier == "reSearch" {
            if let searchVC = segue.destinationViewController as? TweetTableViewController {
                let cell = sender as? UITableViewCell
                searchVC.searchText = cell?.textLabel?.text
            }
        } else if segue.identifier == "showURL" {
            if let URLVC = segue.destinationViewController as? URLViewController {
                if let cell = sender as? UITableViewCell {
                    URLVC.url = NSURL(string: (cell.textLabel?.text)!)
                }
            }
        }
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if indexPath.section == 3 {
//            if let url = NSURL(string: (tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)!) {
//                    UIApplication.sharedApplication().openURL(url)
//            }
//        }
//    }
    
}

