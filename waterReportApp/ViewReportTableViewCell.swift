//
//  ViewReportTableViewCell.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/28/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit

class ViewReportTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var reportNumber: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var waterTypeLabel: UILabel!
    @IBOutlet weak var waterConditionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

