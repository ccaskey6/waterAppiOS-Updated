//
//  WaterCondition.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/28/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit

public enum WaterCondition: String {
    
    case waste = "Waste"
    case treatable_clear = "Treatable - clear"
    case treatable_muddy = "Treatable - muddy"
    case potable = "Potable"
    
    func get() -> String {
        switch self {
        case .waste:
            return "Waste"
        case .treatable_clear:
            return "Treatable - clear"
        case .treatable_muddy:
            return "Treatable - muddy"
        case .potable:
            return "Potable"
        }
    }
    
}
