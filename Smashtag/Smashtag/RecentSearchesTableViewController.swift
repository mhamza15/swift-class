//
//  RecentSearchesTableViewController.swift
//  Smashtag
//
//  Created by Mohamed Hamza on 7/31/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import UIKit
import CoreData

class RecentSearchesTableViewController: UITableViewController {
 
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    @IBAction func clear(sender: UIBarButtonItem) {
        recentSearches?.removeAll()
        tableView.reloadData()
        
    }
    
    
    var recentSearches: [String]? {
        get {
            return NSUserDefaults.standardUserDefaults().stringArrayForKey("recentSearches")
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "recentSearches")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (recentSearches?.count) ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recentSearches", forIndexPath: indexPath)
        cell.textLabel?.text = recentSearches![indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        recentSearches?.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "reSearch" {
            if let destinationVC = segue.destinationViewController as? TweetTableViewController {
                if let cell = sender as? UITableViewCell {
                    destinationVC.searchText = cell.textLabel?.text
                }
            }
        } else if segue.identifier == "searchTermDetails" {
            if let searchDetailsVC = segue.destinationViewController as? SearchTermDetailsTableViewController {
                if let cell = sender as? UITableViewCell {
                    searchDetailsVC.searchTerm = recentSearches![tableView.indexPathForCell(cell)!.row]
                    searchDetailsVC.managedObjectContext = managedObjectContext
                }
            }
        }
    }

}
