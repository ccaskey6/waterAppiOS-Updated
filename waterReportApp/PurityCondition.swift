//
//  PurityCondition.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/30/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit

public enum PurityCondition: String {
    
    case safe = "Safe"
    case treatable = "Treatable"
    case unsafe = "Unsafe"

    func get() -> String {
        switch self {
        case .safe:
            return "Safe"
        case .treatable:
            return "Treatable"
        case .unsafe:
            return "Unsafe"
        }
    }
}
