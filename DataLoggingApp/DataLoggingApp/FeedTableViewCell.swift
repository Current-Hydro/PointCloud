//
//  FeedTableViewCell.swift
//  Hydroelectric App
//
//  Created by Jason Chang on 2/2/17.
//  Copyright © 2017 Jason Chang. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var observationImage: UIImageView!
    @IBOutlet weak var observationTitle: UILabel!
    @IBOutlet weak var observationNote: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
