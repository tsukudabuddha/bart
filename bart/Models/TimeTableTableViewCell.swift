//
//  TimeTableTableViewCell.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/10/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import UIKit

class TimeTableTableViewCell: UITableViewCell {

    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var closestTrainTimeLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var otherTrainEstimatesLabel: UILabel!
    @IBOutlet weak var trainColorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        /* Create white border around each cell */
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.layer.borderWidth = 0.5
        
        /* Make Each Cell transparent °•°° */
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
