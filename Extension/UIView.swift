//
//  UIView.swift
//
//  Created by jangwonhee on 2017. 4. 21..
//  Copyright © 2017년 devmario. All rights reserved.
//

import UIKit

extension UIView {
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame = CGRect(x: newValue, y: y, width: width, height: height)
        }
    }
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame = CGRect(x: x, y: newValue, width: width, height: height)
        }
    }
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame = CGRect(x: x, y: y, width: newValue, height: height)
        }
    }
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame = CGRect(x: x, y: y, width: width, height: newValue)
        }
    }
    var position: CGPoint {
        get {
            return frame.origin
        }
        set {
            frame = CGRect(origin: newValue, size: size)
        }
    }
    var positionAtScreen: CGPoint {
        get {
            if let superview = superview {
                return superview.convert(position, to: nil)
            }
            return CGPoint.zero
        }
    }
    var size: CGSize {
        get {
            return bounds.size
        }
        set {
            frame = CGRect(origin: position, size: newValue)
        }
    }
}
