//
//  TwitterUser+CoreDataProperties.swift
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

extension TwitterUser {

    @NSManaged var name: String?
    @NSManaged var screenName: String?
    @NSManaged var tweets: NSSet?

}
