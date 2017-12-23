//
//  VenuePhotosNetworkModel.swift
//  CaffeineKick
//
//  Created by Chesley Stephens on 12/23/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

import Foundation

struct VenuePhotosNetworkModel: Decodable {
    
    let response: Response!
    
    struct Response: Decodable {
        
        let photos: Photos?
        
        struct Photos: Decodable {
            
            let items: [Photo]?
        }
        
    }
}

struct Photo: Decodable {
    
    let prefix: String!
    let suffix: String!
    let width: Int!
    let height: Int!
}
