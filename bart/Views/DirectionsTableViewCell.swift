//
//  DirectionsTableViewCell.swift
//  bart
//
//  Created by Andrew Tsukuda on 3/11/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import UIKit

class DirectionsTableViewCell: UITableViewCell {

    @IBOutlet weak var originStationLabel: UILabel!
    @IBOutlet weak var originTime: UILabel!
    @IBOutlet weak var destinationStationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
