//
//  Date+TimeInterval.swift
//
//  Created by jangwonhee on 2017. 4. 21..
//  Copyright © 2017년 devmario. All rights reserved.
//

import Foundation

func -(left: Date, right: TimeInterval) -> Date {
    return Date(timeIntervalSince1970: left.timeIntervalSince1970 - right)
}

func -(left: Date, right: Date) -> TimeInterval {
    return left.timeIntervalSince1970 - right.timeIntervalSince1970
}
