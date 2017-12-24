//
//  VenueServiceTests.swift
//  CaffeineKickTests
//
//  Created by Chesley Stephens on 12/23/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

import XCTest
@testable import CaffeineKick

class VenueServiceTests: XCTestCase {
    
    // MARK - RetrieveVenues Tests
    
    func testRetrieveVenues_BadLatLong() {
        let networkManager = NetworkManager()
        let venueService = VenueService(networkManager: networkManager)
        
        let expectation = XCTestExpectation()
        venueService.retrieveVenues(latitude: 0, longitude: 0) { venues in
            expectation.fulfill()
            XCTAssertNil(venues)
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRetrieveVenues_NoVenues() {
        let networkManager = NetworkManager()
        let venueService = VenueService(networkManager: networkManager)
        
        let expectation = XCTestExpectation()
        venueService.retrieveVenues(latitude: 10, longitude: 10) { venues in
            expectation.fulfill()
            XCTAssertTrue(venues?.count == 0)
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRetrieveVenues_VenuesHome() {
        let networkManager = NetworkManager()
        let venueService = VenueService(networkManager: networkManager)
        
        let expectation = XCTestExpectation()
        venueService.retrieveVenues(latitude: 30.326411, longitude: -97.7538074) { venues in
            expectation.fulfill()
            XCTAssertTrue(venues!.count > 10)
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRetrieveVenues_VenuesFlo() {
        let networkManager = NetworkManager()
        let venueService = VenueService(networkManager: networkManager)
        
        let expectation = XCTestExpectation()
        venueService.retrieveVenues(latitude: 30.2634702, longitude: -97.6980923) { venues in
            expectation.fulfill()
            XCTAssertTrue(venues!.count > 10)
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK - RetrieveVenuePhotos Tests
    
    func testRetrieveVenuePhotos_BadVenue() {
        let networkManager = NetworkManager()
        let venueService = VenueService(networkManager: networkManager)
        
        let expectation = XCTestExpectation()
        venueService.retrieveVenuePhotos(venueId: "", completion: { photos in
            expectation.fulfill()
            XCTAssertNil(photos)
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRetrieveVenuePhotos_NoPhotos() {
        let networkManager = NetworkManager()
        let venueService = VenueService(networkManager: networkManager)
        
        let expectation = XCTestExpectation()
        venueService.retrieveVenuePhotos(venueId: "4c615664924b76b0e35cfbb9", completion: { photos in
            expectation.fulfill()
            XCTAssertTrue(photos!.count == 0)
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRetrieveVenuePhotos_SomePhotos() {
        let networkManager = NetworkManager()
        let venueService = VenueService(networkManager: networkManager)
        
        let expectation = XCTestExpectation()
        venueService.retrieveVenuePhotos(venueId: "4bcd94cbcc8cd13aa9b6c2cf", completion: { photos in
            expectation.fulfill()
            XCTAssertTrue(photos!.count > 0)
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK - RetrieveVenueHours Tests
    
    func testRetrieveVenueHours_BadVenue() {
        let networkManager = NetworkManager()
        let venueService = VenueService(networkManager: networkManager)
        
        let expectation = XCTestExpectation()
        venueService.retrieveVenueHours(venueId: "", completion: { hours in
            expectation.fulfill()
            XCTAssertNil(hours)
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRetrieveVenuePhotos_SomeHours() {
        let networkManager = NetworkManager()
        let venueService = VenueService(networkManager: networkManager)
        
        let expectation = XCTestExpectation()
        venueService.retrieveVenueHours(venueId: "4bcd94cbcc8cd13aa9b6c2cf", completion: { hours in
            expectation.fulfill()
            XCTAssertTrue(hours!.timeframes!.count > 0)
        })
        wait(for: [expectation], timeout: 5.0)
    }
}
