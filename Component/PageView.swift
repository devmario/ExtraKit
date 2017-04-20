//
//  PageView.swift
//
//  Created by jangwonhee on 2017. 4. 20..
//  Copyright © 2017년 devmario. All rights reserved.
//

import UIKit

@objc protocol PageViewDelegate {
    func createPage(index: Int) -> [UIView]?
    func bindPage(index: Int, page: [UIView])
    func pageCount() -> Int
}

// TODO: show prev, next page margin property
// TODO: loop property
// TODO: get set index(need normalize with loop)
// TODO: event changed page index
// TODO: page count 1

class PageView: UIView, UIGestureRecognizerDelegate {
    enum Direction {
        case vertical
        case horizontal
    }
    var direction = Direction.vertical
    
    enum Scroll {
        case slide
        case snap
    }
    var scroll = Scroll.snap
    
    weak var delegate: PageViewDelegate? = nil
    
    var panGesture: UIPanGestureRecognizer? = nil
    var isPan: Bool {
        get {
            return panGesture != nil
        }
        set {
            if newValue {
                if panGesture == nil {
                    panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
                    if let panGesture = panGesture {
                        panGesture.cancelsTouchesInView = false
                        addGestureRecognizer(panGesture)
                    }
                }
            } else {
                if panGesture != nil {
                    if let panGesture = panGesture {
                        removeGestureRecognizer(panGesture)
                        self.panGesture = nil
                    }
                }
            }
        }
    }
    
    var touch: UITouch? = nil
    var touchPoint: CGPoint = CGPoint.zero
    
    var force: CGPoint = CGPoint.zero
    
    var dynamic: CGPoint = CGPoint.zero
    var shift: CGPoint = CGPoint.zero
    
    var containerViews:[UIView] = []
    
    var visiblePage:[Int:[UIView]] = [:]
    var hiddenPage:[Int:[UIView]] = [:]
    
    var startIndex: Int = Int.min
    var touchedIndex: Int = Int.min
    
    var index: Int {
        get {
            if direction == .horizontal {
                return Int(-round((dynamic / size).x))
            } else {
                return Int(-round((dynamic / size).y))
            }
        }
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        initialize()
    }
    
    deinit {
        updatable = false
        removeTween()
        print(#file, #line, #function)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        initialize()
    }
    
    func initialize() {
        containerViews.append(UIView())
        containerViews.append(UIView())
        containerViews[0].clipsToBounds = true
        containerViews[1].clipsToBounds = true
        addSubview(containerViews[0])
        addSubview(containerViews[1])
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for container in containerViews {
            container.size = size
        }
        for (_, pages) in visiblePage {
            for page in pages {
                page.size = size
            }
        }
    }
    
    func resetHandler() {
        isPan = superview != nil
        updatable = superview != nil
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        resetHandler()
    }
}

extension PageView {
    override func update(tick: TimeInterval) {
        if touch == nil {
            if scroll == .slide {
                force = force * 0.98
                dynamic = dynamic + force
                updateDynamic()
                if force.distance(point: CGPoint.zero) < 0.1 {
                    updatable = false
                }
            } else {
                updateDynamic()
                updatable = false
            }
        } else {
            updatable = false
        }
    }
    
    func measureDynamic() -> CGPoint {
        guard let delegate = delegate else {
            return CGPoint.zero
        }
        let total = delegate.pageCount()
        let fullSize = size * CGFloat(total)
        var dynamic = self.dynamic
        if direction == .horizontal {
            while dynamic.x > fullSize.width {
                dynamic.x -= fullSize.width
            }
            while dynamic.x < -fullSize.width {
                dynamic.x += fullSize.width
            }
        } else {
            while dynamic.y > fullSize.height {
                dynamic.y -= fullSize.height
            }
            while dynamic.y < -fullSize.height {
                dynamic.y += fullSize.height
            }
        }
        return dynamic
    }
    
    func updateDynamic() {
        guard let delegate = delegate else {
            return
        }
        let total = delegate.pageCount()
        guard total > 0 else {
            return
        }
        var size = self.size
        let dynamic = measureDynamic()
        if scroll == .slide && !hasTween(key: "scroll") {
            self.dynamic = dynamic
        }
        let percent = dynamic / size
        shift = percent - CGPoint(x: Int(percent.x), y: Int(percent.y))
        if direction == .horizontal {
            if shift.x > 0 {
                shift.x -= 1
            }
        } else {
            if shift.y > 0 {
                shift.y -= 1
            }
        }
        shift = shift * size
        var startIndex = Int(floor(-(direction == .horizontal ? percent.x : percent.y)))
        if startIndex < 0 {
            startIndex += total
        }
        if startIndex >= total {
            startIndex -= total
        }
        var nextIndex = startIndex + 1
        if nextIndex >= total {
            nextIndex -= total
        }
        if self.startIndex != startIndex {
            self.startIndex = startIndex
            calculateShowPage(startIndex: startIndex, nextIndex: nextIndex)
        }
        if direction == .horizontal {
            shift.y = 0
            size.height = 0
        } else {
            shift.x = 0
            size.width = 0
        }
        if startIndex % 2 == 0 {
            containerViews[0].position = shift
            containerViews[1].position = shift + size
        } else {
            containerViews[1].position = shift
            containerViews[0].position = shift + size
        }
    }
    
    func showPage(index: Int) {
        guard let delegate = delegate else {
            return
        }
        if !visiblePage.keys.contains(index) {
            if let (_, page) = hiddenPage.popFirst() {
                visiblePage[index] = page
                delegate.bindPage(index: index, page: page)
            } else {
                if let page = delegate.createPage(index: index) {
                    delegate.bindPage(index: index, page: page)
                    if index % 2 == 0 {
                        for view in page {
                            view.size = containerViews[0].size
                            containerViews[0].addSubview(view)
                        }
                    } else {
                        for view in page {
                            view.size = containerViews[1].size
                            containerViews[1].addSubview(view)
                        }
                    }
                    visiblePage[index] = page
                }
            }
        }
    }
    
    func calculateShowPage(startIndex: Int, nextIndex: Int) {
        for (index, page) in visiblePage {
            if index != startIndex && index != nextIndex {
                visiblePage.removeValue(forKey: index)
                hiddenPage[index] = page
            }
        }
        showPage(index: startIndex)
        showPage(index: nextIndex)
    }
}

extension PageView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.touch == nil {
            for touch in touches {
                let point = touch.location(in: self)
                if bounds.contains(point) {
                    removeTween(key: "scroll")
                    touchedIndex = index
                    force = CGPoint.zero
                    touchPoint = point
                    self.touch = touch
                }
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = self.touch {
            if touches.contains(touch) {
                let point = touch.location(in: self)
                dynamic = dynamic + point - touchPoint
                updateDynamic()
                touchPoint = point
            }
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEndedAndCacelled(touches: touches)
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEndedAndCacelled(touches: touches)
        super.touchesCancelled(touches, with: event)
    }
    
    func touchEndedAndCacelled(touches: Set<UITouch>) {
        if let touch = self.touch {
            if touches.contains(touch) {
                if scroll == .snap {
                    if !hasTween(key: "scroll") {
                        scrollIndex(index: index)
                    }
                }
                self.touch = nil
            }
        }
    }
    
    func scrollIndex(index: Int) {
        var from: Double = 0
        var to: Double = 0
        if direction == .horizontal {
            from = Double(dynamic.x)
            to = Double(width) * Double(-index)
        } else {
            from = Double(dynamic.y)
            to = Double(height) * Double(-index)
        }
        addTween(key: "scroll", transition: .expo, equation: .easeOut, from: from, to: to, delay: 0, end: 0.7, step: { [weak self] (value) in
            if let this = self {
                if this.direction == .horizontal {
                    this.dynamic.x = CGFloat(value)
                } else {
                    this.dynamic.y = CGFloat(value)
                }
                this.updateDynamic()
            }
            }, complete: { [weak self] in
                if let this = self {
                    this.dynamic = this.measureDynamic()
                }
        })
    }
    
    func pan(panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .cancelled || panGesture.state == .ended {
            let velocity = panGesture.velocity(in: self)
            if scroll == .slide {
                force = velocity * 0.01
                updatable = true
            } else {
                var throwPage = false
                var target = touchedIndex
                if direction == .horizontal {
                    throwPage = fabs(velocity.x) > width
                    if throwPage {
                        target += velocity.x > 0 ? -1 : 1
                    } else {
                        target = index
                    }
                } else {
                    throwPage = fabs(velocity.y) > height
                    if throwPage {
                        target += velocity.y > 0 ? -1 : 1
                    } else {
                        target = index
                    }
                }
                scrollIndex(index: target)
            }
        }
    }
}
