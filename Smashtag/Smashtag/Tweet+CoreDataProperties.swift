//
//  Tweet+CoreDataProperties.swift
//  Smashtag
//
//  Created by Mohamed Hamza on 8/9/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tweet {

    @NSManaged var posted: NSDate?
    @NSManaged var text: String?
    @NSManaged var unique: String?
    @NSManaged var tweeter: TwitterUser?
    @NSManaged var mentions: NSSet?

}
