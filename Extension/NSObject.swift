//
//  NSObject.swift
//
//  Created by jangwonhee on 2017. 4. 20..
//  Copyright © 2017년 devmario. All rights reserved.
//

import Foundation

extension NSObject {
    func safe(block: os_block_t) {
        objc_sync_enter(self)
        block()
        objc_sync_exit(self)
    }
}

private var propertiesKey:UInt8 = 0

extension NSObject {
    var properties: [String: Any] {
        get {
            return objc_getAssociatedObject(self, &(propertiesKey)) as? [String: Any] ?? [:]
        }
        
        set {
            objc_setAssociatedObject(self, &(propertiesKey), newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var hidden: [String: Any] {
        get {
            return properties["_"] as? [String: Any] ?? [:]
        }
        
        set {
            properties["_"] = newValue
        }
    }
    
    func once(key: String, block: os_block_t) {
        let key = "once_\(key)"
        if let _ = hidden[key] as? Bool {
            return
        }
        block()
        hidden[key] = true
    }
}

extension NSObject {
    var updatable: Bool {
        get {
            return Updater.has(object: self)
        }
        set {
            if newValue {
                Updater.add(object: self)
            } else {
                Updater.remove(object: self)
            }
        }
    }
    
    func update(tick: TimeInterval) {
        
    }
}

extension NSObject {
    func addTween(key: String = "",
                  transition: Tween.Transition = .expo, equation: Tween.Equation = .easeOut,
                  from: Double = 0, to: Double = 1,
                  delay: TimeInterval = 0, end: TimeInterval = 1,
                  step: ((Double) -> Void)? = nil, stepDifference: ((Double) -> Void)? = nil, complete: (() -> Void)? = nil) {
        Tween.add(target: self, key: key, transition: transition, equation: equation, from: from, to: to, delay: delay, end: end, step: step, stepDifference: stepDifference, complete: complete)
    }
    
    func removeTween(key: String = "") {
        Tween.remove(target: self, key: key)
    }
    
    func hasTween(key: String = "") -> Bool {
        return Tween.has(target: self, key: key)
    }
}
