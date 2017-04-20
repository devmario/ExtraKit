//
//  TimeInterval.swift
//
//  Created by jangwonhee on 2017. 4. 21..
//  Copyright © 2017년 devmario. All rights reserved.
//

import Foundation

extension TimeInterval {
    var readable: String {
        let unit = Int(self)
        
        let seconds = unit % 60
        let minutes = (unit / 60) % 60
        let hours = unit / 3600
        let days = hours / 24
        let weeks = days / 7
        let months = days / 30
        let years = days / 365
        
        var array:[(format: String, unit: Int)] = []
        if years > 0 {
            array.append((years == 1 ? "%d year" : "%d years", years))
        } else if months > 0 {
            array.append((months == 1 ? "%d month" : "%d months", months))
        } else if weeks > 0 {
            array.append((weeks == 1 ? "%d week" : "%d weeks", weeks))
        } else if days > 0 {
            array.append((days == 1 ? "%d day" : "%d days", days))
        } else {
            if hours > 0 {
                array.append((minutes > 0 ? "%d H" : (hours == 1 ? "%d hour" : "%d hours"), hours))
            }
            if minutes > 0 {
                array.append((hours > 0 ? "%d M" : (minutes == 1 ? "%d minute" : "%d minutes"), minutes))
            }
            if seconds > 0 && hours == 0 && minutes == 0 {
                array.append(((seconds == 1 ? "%d second" : "%d seconds"), seconds))
            }
        }
        
        var result:[String] = []
        for element in array {
            result.append(String(format: element.format, element.unit) as String)
        }
        return result.joined(separator: " ")
    }
}
