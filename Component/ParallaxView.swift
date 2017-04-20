//
//  ParallaxView.swift
//
//  Created by jangwonhee on 2017. 4. 20..
//  Copyright © 2017년 devmario. All rights reserved.
//

import UIKit

class ParallaxView: UIView {
    var _parallaxDepth: (min: CGFloat, max:CGFloat) = (CGFloat(-1), CGFloat(0))
    var parallaxDepth: (min: CGFloat, max:CGFloat) {
        get {
            return _parallaxDepth
        }
        set {
            _parallaxDepth = newValue
            parallax()
        }
    }
    
    var parallaxMargin: CGSize = CGSize.zero
    
    override func didAddSubview(_ subview: UIView) {
        parallax()
    }
    
    override func didMoveToSuperview() {
        clipsToBounds = true
        parallax()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        parallax()
    }
    
    func parallax() {
        let step = (parallaxDepth.max - parallaxDepth.min) / CGFloat(subviews.count - 1)
        var depth = parallaxDepth.min
        for subview in subviews {
            subview.size = size - parallaxMargin
            subview.center = (position * depth) + size * 0.5
            depth += step
        }
    }
}
