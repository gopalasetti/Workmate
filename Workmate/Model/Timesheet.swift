//
//  Timesheet.swift
//  Workmate
//
//  Created by gsiva on 25/2/20.
//  Copyright © 2020 gsiva. All rights reserved.
//

import Foundation

struct ClockInTimeSheet: Decodable {
    let clockInTime: Date
}

struct ClockOutTimeSheet: Decodable {
    let clockInTime: String
    let clockOutTime: String
    
    enum CodingKeys: String, CodingKey {
        case timesheet = "timesheet"
        case clockInTime = "clockInTime"
        case clockOutTime = "clockOutTime"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timesheet = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .timesheet)
        clockInTime = try timesheet.decode(String.self, forKey: .clockInTime)
        clockOutTime = try timesheet.decode(String.self, forKey: .clockOutTime)
    }
}
