//
//  Updater.swift
//
//  Created by jangwonhee on 2017. 4. 19..
//  Copyright © 2017년 devmario. All rights reserved.
//

import Foundation

class Updater {
    static var timer: Timer? = nil
    static var map: [Int: Unmanaged<NSObject>] = [:]
    static var time: TimeInterval = 0
    
    static func start() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            time = Date().timeIntervalSince1970
        }
    }
    
    static func stop() {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    @objc static func update(timer: Timer) {
        let current = Date().timeIntervalSince1970
        let tick = current - time
        time = current
        
        for (_, value) in map {
            value.takeUnretainedValue().update(tick: tick)
        }
    }
    
    static func has(object: NSObject) -> Bool {
        if let _ = map[object.hashValue] {
            return true
        }
        return false
    }
    
    static func add(object: NSObject) {
        if !has(object: object) {
            let unmanaged = Unmanaged.passRetained(object)
            unmanaged.release()
            map[object.hashValue] = unmanaged
            checkUpdate()
        }
    }
    
    static func remove(object: NSObject) {
        map.removeValue(forKey: object.hashValue)
        checkUpdate()
    }
    
    static func checkUpdate() {
        if map.count > 0 {
            start()
        } else {
            stop()
        }
    }
}
