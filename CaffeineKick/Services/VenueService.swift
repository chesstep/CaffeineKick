//
//  VenueService.swift
//  CaffeineKick
//
//  Created by Chesley Stephens on 12/23/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

import Foundation
import CoreLocation

typealias VenuesRequestCompletion = ([Venue]?) -> Void
typealias VenuePhotosRequestCompletion = ([Photo]?) -> Void
typealias VenueHoursRequestCompletion = (Hours?) -> Void

class VenueService {
    
    let fourSquareEndpoint = "https://api.foursquare.com/v2"
    let clientId = "YPQTNJMTZL0YIFMGYXMSKYW2TOKAST5J4FM1ZBF2DK0VAEZB"
    let clientSecret = "WKNUIW0O423ZZDBBRP4YQBCQVQWZ15GRT1W1V5WUKIYAPPG0"
    let version = "20171223"

    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func retrieveVenues(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: VenuesRequestCompletion?) {
        let venueSearchEndpoint = "\(fourSquareEndpoint)/venues/search"
        let parameters = ["query": "coffee", "ll": "\(latitude),\(longitude)", "client_id": clientId, "client_secret": clientSecret, "v": version, "radius": "4828.03"]
        
        networkManager.get(endpoint: venueSearchEndpoint, parameters: parameters, responseModel: VenuesNetworkModel.self) { result in
            switch result {
            case .success(let venuesNetworkModel):
                if let venuesNetworkModel = venuesNetworkModel as? VenuesNetworkModel {
                    completion?(venuesNetworkModel.response.venues)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion?(nil)
            }
        }
    }
    
    func retrieveVenuePhotos(venueId: String, completion: VenuePhotosRequestCompletion?) {
        let venuePhotoEndpoint = "\(fourSquareEndpoint)/venues/\(venueId)/photos"
        let parameters = ["limit": 5, "client_id": clientId, "client_secret": clientSecret, "v": version] as [String : Any]
        
        networkManager.get(endpoint: venuePhotoEndpoint, parameters: parameters, responseModel: VenuePhotosNetworkModel.self) { result in
            switch result {
            case .success(let venuePhotosNetworkModel):
                if let venuePhotosNetworkModel = venuePhotosNetworkModel as? VenuePhotosNetworkModel {
                    completion?(venuePhotosNetworkModel.response.photos?.items)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion?(nil)
            }
        }
    }
    
    func retrieveVenueHours(venueId: String, completion: VenueHoursRequestCompletion?) {
        let venueHoursEndpoint = "\(fourSquareEndpoint)/venues/\(venueId)/hours"
        let parameters = ["client_id": clientId, "client_secret": clientSecret, "v": version]
        
        networkManager.get(endpoint: venueHoursEndpoint, parameters: parameters, responseModel: VenueHoursNetworkModel.self) { result in
            switch result {
            case .success(let venueHoursNetworkModel):
                if let venueHoursNetworkModel = venueHoursNetworkModel as? VenueHoursNetworkModel {
                    completion?(venueHoursNetworkModel.response.hours)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion?(nil)
            }
        }
    }
}
