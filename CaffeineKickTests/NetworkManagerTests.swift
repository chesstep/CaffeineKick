//
//  CaffeineKickTests.swift
//  CaffeineKickTests
//
//  Created by Chesley Stephens on 12/21/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

import XCTest
@testable import CaffeineKick

class NetworkManagerTests: XCTestCase {
    
    // MARK - GenerateRequest Tests
    
    func testRetrieveVenues_NoParameters() {
        let networkManager = NetworkManager()
        let url = URL(string: "https://google.com")!
        
        let expectedResult = URLRequest(url: url)
        let result = networkManager.generateRequest(url: url, httpMethod: .GET, parameters: nil)
        
        XCTAssertTrue(expectedResult == result)
    }
    
    func testRetrieveVenues_Parameters() {
        let networkManager = NetworkManager()
        
        let expectedURL = URL(string: "https://google.com?test=hey")!
        let expectedResult = URLRequest(url: expectedURL)
        
        let resultURL = URL(string: "https://google.com")!
        let result = networkManager.generateRequest(url: resultURL, httpMethod: .GET, parameters: ["test": "hey"])
        
        XCTAssertTrue(expectedResult == result)
    }
    
    // MARK - FormatRequestParameters Tests
    
    func testFormatRequestParameters_NoParameters() {
        let networkManager = NetworkManager()
        let url = URL(string: "https://google.com")!
        
        let expectedResult = URLRequest(url: url)
        let result = networkManager.formatRequestParameters(request: URLRequest(url: url), parameters: nil)
        
        XCTAssertTrue(expectedResult == result)
    }
    
    func testFormatRequestParameters_Parameters() {
        let networkManager = NetworkManager()
        
        let expectedURL = URL(string: "https://google.com?test=hey")!
        let expectedResult = URLRequest(url: expectedURL)
        
        let resultURL = URL(string: "https://google.com")!
        let result = networkManager.formatRequestParameters(request: URLRequest(url: resultURL), parameters:  ["test": "hey"])
        
        XCTAssertTrue(expectedResult == result)
    }
    
    // MARK - UrlEncode Tests
    
    func testFormatRequestParameters_NoEncoding() {
        let networkManager = NetworkManager()
        
        let expectedResult = "test=hey"
        let result = networkManager.urlEncode(string: "test=hey")
        
        XCTAssertTrue(expectedResult == result)
    }
    
    func testFormatRequestParameters_Encoding() {
        let networkManager = NetworkManager()
        
        let expectedResult = "test=hey%3F%40"
        let result = networkManager.urlEncode(string: "test=hey?@")
        
        XCTAssertTrue(expectedResult == result)
    }
    
    // MARK - HttpParametersString Tests
    
    func testHttpParametersString_NoParameters() {
        let networkManager = NetworkManager()
        
        let expectedResult = ""
        let result = networkManager.httpParametersString(parameters: [:])
        
        XCTAssertTrue(expectedResult == result)
    }
    
    func testHttpParametersString_OneStringParameter() {
        let networkManager = NetworkManager()
        
        let expectedResult = "test=hey"
        let result = networkManager.httpParametersString(parameters: ["test": "hey"])
        
        XCTAssertTrue(expectedResult == result)
    }
    
    func testHttpParametersString_OneIntParameter() {
        let networkManager = NetworkManager()
        
        let expectedResult = "test=1"
        let result = networkManager.httpParametersString(parameters: ["test": 1])
        
        XCTAssertTrue(expectedResult == result)
    }
    
    func testHttpParametersString_OneDoubleParameter() {
        let networkManager = NetworkManager()
        
        let expectedResult = "test=1.222"
        let result = networkManager.httpParametersString(parameters: ["test": 1.222])
        
        XCTAssertTrue(expectedResult == result)
    }
    
    func testHttpParametersString_TwoStringParameter() {
        let networkManager = NetworkManager()
        
        let expectedResult = "test=hey&batman=dude"
        let result = networkManager.httpParametersString(parameters: ["test": "hey", "batman": "dude"])
        
        XCTAssertTrue(expectedResult == result)
    }
    
    func testHttpParametersString_TwoIntParameter() {
        let networkManager = NetworkManager()
        
        let expectedResult = "test=1&batman=2"
        let result = networkManager.httpParametersString(parameters: ["test": 1, "batman": 2])
        
        XCTAssertTrue(expectedResult == result)
    }
    
    func testHttpParametersString_TwoDoubleParameter() {
        let networkManager = NetworkManager()
        
        let expectedResult = "test=1.222&batman=2"
        let result = networkManager.httpParametersString(parameters: ["test": 1.222, "batman": 2])
        
        XCTAssertTrue(expectedResult == result)
    }
}
