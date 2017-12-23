//
//  VenueAnnotation.swift
//  CaffeineKick
//
//  Created by Chesley Stephens on 12/23/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

import Foundation
import MapKit

class VenueAnnotation: NSObject, MKAnnotation {
    
    let venue: Venue
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(venue: Venue) {
        self.venue = venue
        coordinate = CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng)
        title = venue.name
        subtitle = venue.location.address
    }
}
