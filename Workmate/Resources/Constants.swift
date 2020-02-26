//
//  Constants.swift
//  Workmate
//
//  Created by gsiva on 25/2/20.
//  Copyright © 2020 gsiva. All rights reserved.
//

import Foundation

struct Constants {
    
    static let serviceBaseURL = "https://api.helpster.tech/v1"
    
    enum ServiceEndPoint: String {
        case login = "auth/login/"
        case job = "staff-requests/26074/"
        case clockIn = "staff-requests/26074/clock-in/"
        case clockOut = "staff-requests/26074/clock-out/"
    }

    enum TimeSheetState {
        case clockIn
        case clockOut
    }

}


