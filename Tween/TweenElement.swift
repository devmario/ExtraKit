//
//  TweenElement.swift
//
//  Created by jangwonhee on 2017. 4. 20..
//  Copyright © 2017년 devmario. All rights reserved.
//

import Foundation

class TweenElement: Hashable {
    var transition: Tween.Transition = .expo
    var equation: Tween.Equation = .easeOut
    var from: Double = 0
    var to: Double = 1
    var value: Double = 0
    var delay: TimeInterval = 0
    var current: TimeInterval = 0
    var end: TimeInterval = 1
    var step: ((Double) -> Void)? = nil
    var stepDifference: ((Double) -> Void)? = nil
    var complete: (() -> Void)? = nil
    
    var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    func step(tick: TimeInterval) -> Bool {
        current += tick
        if let easing = Tween.transitions[transition] {
            let oldValue = value
            if current > delay {
                let b = from
                let c = to - from
                var t = current - delay
                let d = end
                if t > end {
                    t = end
                }
                switch equation {
                case .easeIn:
                    value = easing.easeIn(t:t,b:b,c:c,d:d)
                case .easeOut:
                    value = easing.easeOut(t:t,b:b,c:c,d:d)
                case .easeInOut:
                    value = easing.easeInOut(t:t,b:b,c:c,d:d)
                }
                let ended =  t >= end
                if ended {
                    value = to
                }
                step?(value)
                stepDifference?(value - oldValue)
                return ended
            } else {
                return false
            }
        } else {
            return true
        }
    }
}

func == (left: TweenElement, right: TweenElement) -> Bool {
    return left.hashValue == right.hashValue
}
