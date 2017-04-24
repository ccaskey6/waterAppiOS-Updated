//
//  WaterType.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/28/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit

public enum WaterType: String {
    
    case bottled = "Bottled"
    case well = "Well"
    case stream = "Stream"
    case lake = "Lake"
    case spring = "Spring"
    case other = "Other"
    
    func get() -> String {
        switch self {
        case .bottled:
            return "Bottled"
        case .well:
            return "Well"
        case .stream:
            return "Stream"
        case .lake:
            return "Lake"
        case .spring:
            return "Spring"
        case .other:
            return "Other"
        }
    }
    
}
