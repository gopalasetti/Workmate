//
//  Job.swift
//  Workmate
//
//  Created by gsiva on 25/2/20.
//  Copyright © 2020 gsiva. All rights reserved.
//

import Foundation

struct Job: Decodable {
    let positionName: String
    let clientName: String
    let address: String
    let wageAmount: String
    let wageType: String
    let managerName: String
    let managerNumber: String
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
        case position = "position"
        case address = "address"
        case street = "street1"
        case client = "client"
        case name = "name"
        case wageAmount = "wageAmount"
        case manager = "manager"
        case phone = "phone"
        case wageType = "wageType"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let client = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .client)
        clientName = try client.decode(String.self, forKey: .name)

        let position = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .position)
        positionName = try position.decode(String.self, forKey: .name)

        let location = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .location)
        let locationAddress = try location.nestedContainer(keyedBy: CodingKeys.self, forKey: .address)
        address = try locationAddress.decode(String.self, forKey: .street)

        let manager = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .manager)
        managerName = try manager.decode(String.self, forKey: .name)
        managerNumber = try manager.decode(String.self, forKey: .phone)
        
        wageAmount = try container.decode(String.self, forKey: .wageAmount)
        wageType = try container.decode(String.self, forKey: .wageType)
    }
    
}

struct Login: Decodable {
    let key: String
}

