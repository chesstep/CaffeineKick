//
//  VenueNetworkModel.swift
//  CaffeineKick
//
//  Created by Chesley Stephens on 12/23/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

import Foundation

struct VenuesNetworkModel: Decodable {
    
    let response: Response!
    
    struct Response: Decodable {
        
        let venues: [Venue]?
    }
}

struct Venue: Decodable {
    
    let id: String!
    let name: String!
    let location: Location!
    let stats: Stats!
    
    struct Location: Decodable {
        
        let address: String?
        let lat: Double!
        let lng: Double!
        let distance: Int!
        
        var distanceInMiles: String {
            return (distance != nil) ? String(format: "%.2f miles", Double(distance!) * 0.00062137) : ""
        }
    }
    
    struct Stats: Decodable {
        
        let checkinsCount: Int!
    }
}
