//
//  StationTableViewCell.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/8/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        /* Create white border around each cell */
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.layer.borderWidth = 0.5
        
        /* Make Each Cell transparent °•°° */
        self.backgroundColor = UIColor.clear
        selectedBackgroundView?.backgroundColor = UIColor.clear
        
        /* Change text color to white */
        self.textLabel?.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
