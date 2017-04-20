//
//  Foundation.swift
//
//  Created by jangwonhee on 2017. 4. 20..
//  Copyright © 2017년 devmario. All rights reserved.
//

import UIKit

prefix func ++(x: inout Int) -> Int {
    x += 1
    return x
}

postfix func ++(x: inout Int) -> Int {
    x += 1
    return (x - 1)
}

prefix func ++(x: inout Double) -> Double {
    x += 1
    return x
}

postfix func ++(x: inout Double) -> Double {
    x += 1
    return (x - 1)
}
