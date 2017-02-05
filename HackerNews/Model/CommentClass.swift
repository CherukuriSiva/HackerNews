//
//  Comments.swift
//  HackerNews
//
//  Created by Siva Cherukuri on 04/02/17.
//  Copyright © 2017 Ducere. All rights reserved.
//

import UIKit

/*!
 * @discussion Comments Model class to store comments data
 */
class CommentClass: NSObject
{
    var kidsArray: NSArray?
    var descendants: NSNumber?
    var score: NSNumber?
    var id: NSNumber?
    var by: String?
    var title: String?
    var type: String!
    var time: NSNumber?
    var url: String?
    
    
    override init () {

    }
    
    convenience init(_ comments: Dictionary<String, AnyObject>)
    {
        
        self.init()
        
        self.kidsArray = comments["kids"] as? NSArray
        self.descendants = comments["descendants"] as? NSNumber
        self.score = comments["score"] as? NSNumber
        self.id = comments["id"] as? NSNumber
        self.by = comments["by"] as? String
        self.title = comments["title"] as? String
        self.type = comments["type"] as? String
        self.time = comments["time"] as? NSNumber
        self.url = comments["url"] as? String

        
    }
}
