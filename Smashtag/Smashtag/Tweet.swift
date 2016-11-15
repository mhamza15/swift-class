//
//  Tweet.swift
//  Smashtag
//
//  Created by Mohamed Hamza on 8/8/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import Foundation
import CoreData
import Twitter

class Tweet: NSManagedObject {
    
    class func tweetWithTwitterInfo(twitterInfo: Twitter.Tweet, searchTerm: String, inManagedObjectContext context: NSManagedObjectContext) -> Tweet? {
        
        let request = NSFetchRequest(entityName: "Tweet")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id)
        
        if let tweet = (try? context.executeFetchRequest(request))?.first as? Tweet {
            return tweet
        } else if let tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweet", inManagedObjectContext: context) as? Tweet {
            tweet.unique = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.posted = twitterInfo.created
            tweet.tweeter = TwitterUser.twitterUserWithTwitterInfo(twitterInfo.user, inManagedObjectContext: context)
            let mentionSet = tweet.mutableSetValueForKey("mentions")
            for hashtag in twitterInfo.hashtags {
                if let mention = MentionCountForSearchTerm.createMention(hashtag.keyword, searchTerm: searchTerm, type: "Hashtag", inManagedObjectContext: context) {
                    mentionSet.addObject(mention)
                }
            }
            for user in twitterInfo.userMentions {
                if let mention = MentionCountForSearchTerm.createMention(user.keyword, searchTerm: searchTerm, type: "User", inManagedObjectContext: context) {
                    mentionSet.addObject(mention)
                }
            }
            return tweet
        }
        return nil
    }
    
}
