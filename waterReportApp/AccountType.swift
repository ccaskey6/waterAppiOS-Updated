//
//  AccountType.swift
//  waterReportApp
//
//  Created by Corey Caskey on 3/28/17.
//  Copyright © 2017 Corey Caskey. All rights reserved.
//

import UIKit

public enum AccountType: String {
    
    case user = "User"
    case worker = "Worker"
    case manager = "Manager"
    case admin = "Admin"
    
    func get() -> String {
        switch self {
        case .user:
            return "User"
        case .worker:
            return "Worker"
        case .manager:
            return "Manager"
        case .admin:
            return "Admin"
        }
    }
    
}
