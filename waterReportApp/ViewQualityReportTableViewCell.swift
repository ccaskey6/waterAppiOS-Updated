//
//  ViewQualityReportTableViewCell.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/30/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit

class ViewQualityReportTableViewCell: UITableViewCell {

    @IBOutlet weak var reportNumber: UILabel!
    @IBOutlet weak var dateTimestamp: UILabel!
    @IBOutlet weak var workerName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var virusPPM: UILabel!
    @IBOutlet weak var contaminantPPM: UILabel!
    @IBOutlet weak var address: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
