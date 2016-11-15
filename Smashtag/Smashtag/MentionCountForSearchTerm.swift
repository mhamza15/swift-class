//
//  MetionCountForSearchTerm.swift
//  Smashtag
//
//  Created by Mohamed Hamza on 8/9/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import Foundation
import CoreData
import Twitter


class MentionCountForSearchTerm: NSManagedObject {

    class func createMention(mention: String, searchTerm: String, type: String, inManagedObjectContext context: NSManagedObjectContext) -> MentionCountForSearchTerm? {
        
        let request = NSFetchRequest(entityName: "MentionCountForSearchTerm")
        request.predicate = NSPredicate(format: "text = %@ and searchTerm = %@", mention, searchTerm)
        
        if let mentionEntity = (try? context.executeFetchRequest(request))?.first as? MentionCountForSearchTerm {
            return mentionEntity
        } else if let mentionEntity = NSEntityDescription.insertNewObjectForEntityForName("MentionCountForSearchTerm", inManagedObjectContext: context) as? MentionCountForSearchTerm {
            mentionEntity.searchTerm = searchTerm
            mentionEntity.text = mention
            mentionEntity.type = type
            return mentionEntity
        }
        
        return nil
    
    }
    
    class func updateCountForSearchTerm(searchTerm: String, inManagedObjectContext context: NSManagedObjectContext) {
        
        let request = NSFetchRequest(entityName: "MentionCountForSearchTerm")
        request.predicate = NSPredicate(format: "searchTerm = %@", searchTerm)
        
        if let mentionsArray = (try? context.executeFetchRequest(request)) as? [MentionCountForSearchTerm] {
            for mention in mentionsArray {
                let request = NSFetchRequest(entityName: "Tweet")
                request.predicate = NSPredicate(format: "any mentions = %@", mention)
                let c = context.countForFetchRequest(request, error: nil)
                mention.count = c
            }
        }
        
    }
}
