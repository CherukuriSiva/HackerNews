//
//  ReplyClass.swift
//  HackerNews
//
//  Created by Siva Cherukuri on 06/02/17.
//  Copyright © 2017 Ducere. All rights reserved.
//

import UIKit

/*!
 * @discussion ReplyClass Model to store replies data
 */
class ReplyClass: NSObject {
    
    var by: String?
    var id: NSNumber?
    var kidsArray: NSArray?
    var parentId: NSNumber?
    var text: String?
    var time: NSNumber?
    var type: String!
    
    override init () {
        
    }
    
    convenience init(_ reply: Dictionary<String, AnyObject>)
    {
        
        self.init()
        
        self.by = reply["by"] as? String
        self.id = reply["id"] as? NSNumber
        self.kidsArray = reply["kids"] as? NSArray
        self.parentId = reply["parent"] as? NSNumber
        self.text = reply["text"] as? String
        self.time = reply["time"] as? NSNumber
        self.type = reply["type"] as? String
        
    }
}
