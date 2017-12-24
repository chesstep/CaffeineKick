//
//  VenueHoursNetworkModelTests.swift
//  CaffeineKickTests
//
//  Created by Chesley Stephens on 12/23/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

import XCTest
@testable import CaffeineKick

class VenueHoursNetworkModelTests: XCTestCase {
    
    // MARK - Clean Tests
    
    func testOpenClean_WithPlus() {
        let open = Hours.Timeframe.Open(start: "+0100", end: "+0400")
        
        let expectedStartResult = "01:00"
        let expectedEndResult = "04:00"
        
        let startResult = open.clean(time: open.start)
        let endResult = open.clean(time: open.end)
        
        XCTAssertTrue(expectedStartResult == startResult)
        XCTAssertTrue(expectedEndResult == endResult)
    }
    
    func testOpenClean_NoPlus() {
        let open = Hours.Timeframe.Open(start: "0100", end: "0400")
        
        let expectedStartResult = "01:00"
        let expectedEndResult = "04:00"
        
        let startResult = open.clean(time: open.start)
        let endResult = open.clean(time: open.end)
        
        XCTAssertTrue(expectedStartResult == startResult)
        XCTAssertTrue(expectedEndResult == endResult)
    }
    
    // MARK - DayString Tests
    
    func testDayString_NoDays() {
        let open = Hours.Timeframe.Open(start: "0100", end: "0400")
        let timeframe = Hours.Timeframe(days: [], open: [open])
        
        let expectedResult = ""
        
        let result = timeframe.daysString()
        
        XCTAssertTrue(expectedResult == result)
    }
    
    func testDayString_OneDays() {
        let open = Hours.Timeframe.Open(start: "0100", end: "0400")
        let timeframe = Hours.Timeframe(days: [2], open: [open])
        
        let expectedResult = "Tue"
        
        let result = timeframe.daysString()
        
        XCTAssertTrue(expectedResult == result)
    }
    
    func testDayString_MultipleDays() {
        let open = Hours.Timeframe.Open(start: "0100", end: "0400")
        let timeframe = Hours.Timeframe(days: [2, 3, 5], open: [open])
        
        let expectedResult = "Tue, Wed, Fri"
        
        let result = timeframe.daysString()
        
        XCTAssertTrue(expectedResult == result)
    }
    
    // MARK - FormatHoursString Tests
    
    func testFormatHoursString_NoTimeframes() {
        let hours = Hours(timeframes: nil)
        let result = hours.formatHoursString()
        
        XCTAssertNil(result)
    }
    
    func testFormatHoursString_EmptyTimeframes() {
        let hours = Hours(timeframes: [])
        
        let expectedResult = ""
        
        let result = hours.formatHoursString()
        
        XCTAssertTrue(expectedResult == result)
    }
    
    func testFormatHoursString_OneTimeframe() {
        let open = Hours.Timeframe.Open(start: "0100", end: "0400")
        let timeframe = Hours.Timeframe(days: [1], open: [open])
        let hours = Hours(timeframes: [timeframe])
        
        let expectedResult = "Mon 1:00AM-4:00AM"
        
        let result = hours.formatHoursString()
        
        XCTAssertTrue(expectedResult == result)
    }
    
    func testFormatHoursString_TwoTimeframe() {
        let open1 = Hours.Timeframe.Open(start: "0100", end: "0400")
        let timeframe1 = Hours.Timeframe(days: [1], open: [open1])
        
        let open2 = Hours.Timeframe.Open(start: "+1200", end: "+0000")
        let timeframe2 = Hours.Timeframe(days: [6, 7], open: [open2])
        
        let hours = Hours(timeframes: [timeframe1, timeframe2])
        
        let expectedResult = "Mon 1:00AM-4:00AM, Sat, Sun 12:00PM-12:00AM"
        
        let result = hours.formatHoursString()
        
        XCTAssertTrue(expectedResult == result)
    }
    
    func testFormatHoursString_BadTimeframe() {
        let open1 = Hours.Timeframe.Open(start: "010020", end: "04020")
        let timeframe1 = Hours.Timeframe(days: [1], open: [open1])
        
        let open2 = Hours.Timeframe.Open(start: "+12010", end: "+022000")
        let timeframe2 = Hours.Timeframe(days: [6, 7], open: [open2])
        
        let hours = Hours(timeframes: [timeframe1, timeframe2])
        
        let expectedResult = "Mon, Sat, Sun"
        
        let result = hours.formatHoursString()
        
        XCTAssertTrue(expectedResult == result)
    }
}
