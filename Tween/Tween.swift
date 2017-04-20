//
//  Tween.swift
//
//  Created by jangwonhee on 2017. 4. 19..
//  Copyright © 2017년 devmario. All rights reserved.
//

import Foundation

class Tween: NSObject {
    static let share: Tween = Tween()
    
    enum Equation {
        case easeIn
        case easeOut
        case easeInOut
    }
    
    enum Transition {
        case linear
        case sine
        case quint
        case quart
        case quad
        case expo
        case elastic
        case cubic
        case circ
        case bounce
        case back
    }
    
    static let transitions:[Transition:Easing] = [
        .linear: Linear(),
        .sine: Sine(),
        .quint: Quint(),
        .quart: Quart(),
        .quad: Quad(),
        .expo: Expo(),
        .elastic: Elastic(),
        .cubic: Cubic(),
        .circ: Circ(),
        .bounce: Bounce(),
        .back: Back()
    ]
    
    var animation:[Int: [String: TweenElement]] = [:]
    
    struct Keys {
        var targetHashValue: Int
        var key: String
        
        init(target: NSObject, key: String = "") {
            self.targetHashValue = target.hashValue
            self.key = key
        }
        
        init(targetHashValue: Int, key: String = "") {
            self.targetHashValue = targetHashValue
            self.key = key
        }
    }
    
    static func add(target: NSObject, key: String = "",
                    transition: Transition = Transition.expo, equation: Equation = Equation.easeOut,
                    from: Double = 0, to: Double = 1,
                    delay: TimeInterval = 0, end: TimeInterval = 1,
                    step: ((Double) -> Void)? = nil, stepDifference: ((Double) -> Void)? = nil, complete: (() -> Void)? = nil) {
        let keys = Tween.remove(target: target, key: key)
        if !Tween.share.animation.keys.contains(keys.targetHashValue) {
            Tween.share.animation[keys.targetHashValue] = [:]
        }
        let element = TweenElement()
        element.transition = transition
        element.equation = equation
        element.from = from
        element.to = to
        element.value = from
        element.delay = delay
        element.current = 0
        element.end = end
        element.step = step
        element.stepDifference = stepDifference
        element.complete = complete
        Tween.share.animation[keys.targetHashValue]?[keys.key] = element
        Tween.share.updatable = true
    }
    
    static func has(target: NSObject, key: String = "") -> Bool {
        if let inmap = Tween.share.animation[target.hashValue] {
            if key == "" && inmap.count > 0 {
                return true
            }
            if let _ = inmap[key] {
                return true
            }
            return false
        } else {
            return false
        }
    }
    
    @discardableResult static func remove(target: NSObject, key: String = "") -> Keys {
        let keys = Keys(target: target, key: key)
        return remove(keys: keys)
    }
    
    @discardableResult static func remove(keys: Keys) -> Keys {
        if keys.key != "" {
            Tween.share.safe {
                Tween.share.animation[keys.targetHashValue]?.removeValue(forKey: keys.key)
            }
            return keys
        }
        Tween.share.safe {
            Tween.share.animation.removeValue(forKey: keys.targetHashValue)
        }
        return keys
    }
    
    override func update(tick: TimeInterval) {
        super.update(tick: tick)
        
        var removedStack:[(targetHashValue: Int, key: String, element: TweenElement)] = []
        Tween.share.safe {
            var step = false
            for (targetHashValue, dictionary) in animation {
                for (key, element) in dictionary {
                    if element.step(tick: tick) {
                        if let element = Tween.share.animation[targetHashValue]?.removeValue(forKey: key) {
                            removedStack.append((targetHashValue, key, element))
                        }
                    }
                    step = true
                }
            }
            
            if !step {
                updatable = false
                animation = [:]
            }
        }
        
        for removed in removedStack {
            Tween.remove(keys: Keys(targetHashValue: removed.targetHashValue, key: removed.key))
            removed.element.complete?()
        }
    }
}
