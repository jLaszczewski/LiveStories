//
//  StoryCell.swift
//  LiveStories
//
//  Created by Jakub Łaszczewski on 13.04.2018.
//  Copyright © 2018 Jakub Łaszczewski. All rights reserved.
//

import UIKit

class StoryCell: UITableViewCell {
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var rightMargin: NSLayoutConstraint!
    @IBOutlet weak var leftMargin: NSLayoutConstraint!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var leftMarginGreaterThan: NSLayoutConstraint!
    @IBOutlet weak var rightMarginGraterThan: NSLayoutConstraint!
    @IBOutlet weak var leftCorner: UIView!
    @IBOutlet weak var rightCorner: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
