//
//  SearchTermDetailsTableViewController.swift
//  Smashtag
//
//  Created by Mohamed Hamza on 8/9/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import UIKit
import CoreData

class SearchTermDetailsTableViewController: CoreDataTableViewController {

    var searchTerm: String? { didSet { updateUI() } }
    
    var managedObjectContext: NSManagedObjectContext? { didSet { updateUI() } }
    
    private func updateUI() {
        if let context = managedObjectContext where searchTerm?.characters.count > 0 {
            let request = NSFetchRequest(entityName: "MentionCountForSearchTerm")
            request.predicate = NSPredicate(format: "searchTerm = %@", searchTerm!)
            request.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true), NSSortDescriptor(key: "count", ascending: false)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "type", cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mentionCell", forIndexPath: indexPath)
        if let mention = fetchedResultsController?.objectAtIndexPath(indexPath) as? MentionCountForSearchTerm {
            cell.textLabel?.text = mention.text
            cell.detailTextLabel?.text = mention.count == 1 ? "1 Tweet" : "\(mention.count!) Tweets"
        }
        return cell
    }


}
