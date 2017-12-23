//
//  VenueHoursNetworkModel.swift
//  CaffeineKick
//
//  Created by Chesley Stephens on 12/23/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

import Foundation

struct VenueHoursNetworkModel: Decodable {
    
    let response: Response!
    
    struct Response: Decodable {
        
        let hours: Hours?
    }
}

struct Hours: Decodable {
    
    let timeframes: [Timeframe]?
    
    struct Timeframe: Decodable {
        
        let days: [Int]!
        let open: [Open]!
        
        struct Open: Decodable {
            
            let start: String!
            let end: String!
            
            func clean(time: String) -> String {
                var formattedTime = time
                if let index = formattedTime.index(of: "+") {
                    formattedTime.remove(at: index)
                }
                formattedTime.insert(":", at: formattedTime.index(formattedTime.endIndex, offsetBy: -2))
                
                return formattedTime
            }
        }
        
        func daysString() -> String {
            var daysString = ""
            guard let days = days else {
                return daysString
            }
            
            for index in 0..<days.count {
                let day = days[index]
                
                switch day {
                case 1:
                    daysString += "Mon"
                case 2:
                    daysString += "Tue"
                case 3:
                    daysString += "Wed"
                case 4:
                    daysString += "Thu"
                case 5:
                    daysString += "Fri"
                case 6:
                    daysString += "Sat"
                case 7:
                    daysString += "Sun"
                default:
                    break
                }
                
                if index + 1 < days.count {
                    daysString += ", "
                }
            }
            return daysString
        }
            
    }
    
    func formatHoursString() -> String? {
        guard let timeframes = timeframes else {
            return nil
        }
        
        var hoursString = ""
        let dateFormatter = DateFormatter()
        for index in 0..<timeframes.count {
            let timeframe = timeframes[index]
            hoursString += timeframe.daysString()
            
            for open in timeframe.open {
                dateFormatter.dateFormat = "HH:mm"
                
                let formattedStart = open.clean(time: open.start)
                let formattedEnd = open.clean(time: open.end)
                
                let startDate = dateFormatter.date(from: formattedStart)!
                let endDate = dateFormatter.date(from: formattedEnd)!
                
                dateFormatter.dateFormat = "h:mma"
                
                hoursString += " \(dateFormatter.string(from: startDate))-\(dateFormatter.string(from: endDate))"
                
                if index + 1 < timeframes.count {
                    hoursString += ", "
                }
            }
        }
        return hoursString
    }
}
