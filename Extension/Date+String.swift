//
//  Date+String.swift
//
//  Created by jangwonhee on 2017. 4. 21..
//  Copyright © 2017년 devmario. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let defaultDateFormat:String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    func set(timeZone: TimeZone, format :String) -> Self {
        self.dateFormat = format
        self.timeZone = timeZone
        return self
    }
}

extension Date {
    func string(timeZone: TimeZone? = TimeZone.current, format :String = DateFormatter.defaultDateFormat) -> String? {
        if let timeZone = timeZone {
            return DateFormatter().set(timeZone: timeZone, format: format).string(from: self)
        } else {
            return nil
        }
    }
}

extension String {
    func date(timeZone: TimeZone? = TimeZone.current, format: String = DateFormatter.defaultDateFormat) -> Date? {
        if let timeZone = timeZone {
            return DateFormatter().set(timeZone: timeZone, format: format).date(from: self)
        }
        return nil
    }
}
