//
//  ExpandableCell.swift
//  ExpandableCellsExample
//
//  Created by DC on 28.08.2016.
//  Copyright © 2016 Dawid Cedrych. All rights reserved.
//

import UIKit

class ExpandableCell: UITableViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!


    @IBOutlet weak var replyLableHeightConstraint: NSLayoutConstraint!

    var isExpanded:Bool = false
        {
        didSet
        {
            if !isExpanded {
                self.replyLableHeightConstraint.constant = 0.0
                
            } else {
                self.replyLableHeightConstraint.constant = 210.0
            }
        }
    }

}
