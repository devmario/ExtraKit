//
//  ParallaxPageView.swift
//
//  Created by jangwonhee on 2017. 4. 16..
//  Copyright © 2017년 devmario. All rights reserved.
//

import UIKit

class ParallaxPageView : PageView {
    var parallaxDepth: (min: CGFloat, max:CGFloat) {
        get {
            return (containerViews.first as! ParallaxView).parallaxDepth
        }
        set {
            (containerViews.first as! ParallaxView).parallaxDepth = newValue
            (containerViews.last as! ParallaxView).parallaxDepth = newValue
        }
    }
    
    var parallaxMargin: CGSize = CGSize.zero {
        didSet {
            (containerViews.first as! ParallaxView).parallaxMargin = parallaxMargin
            (containerViews.last as! ParallaxView).parallaxMargin = parallaxMargin
        }
    }
    
    override func initialize() {
        containerViews.append(ParallaxView())
        containerViews.append(ParallaxView())
        addSubview(containerViews[0])
        addSubview(containerViews[1])
    }
}
