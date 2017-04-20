//
//  Easing.swift
//
//  Created by jangwonhee on 2017. 4. 20..
//  Copyright © 2017년 devmario. All rights reserved.
//

import Foundation

protocol Easing {
    func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double
    func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double
    func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double
}

class Linear: Easing {
    func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        return c*t/d + b
    }
    func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        return c*t/d + b
    }
    func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        return c*t/d + b
    }
}

class Sine: Easing {
    func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        return -c * cos(t/d * (Double.pi/2)) + c + b
    }
    func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        return c * sin(t/d * (Double.pi/2)) + b
    }
    func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        return -c/2 * (cos(Double.pi*t/d) - 1) + b
    }
}

class Quint: Easing {
    func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t = t/d
        return c*t*t*t*t*t + b
    }
    func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t = t/d-1
        return c*(t*t*t*t*t + 1) + b
    }
    func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        var t = t/(d/2)
        if (t < 1) {
            return c/2*t*t*t*t*t + b
        }
        t = t-2
        return c/2*(t*t*t*t*t + 2) + b;
    }
}

class Quart: Easing {
    func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t = t/d
        return c*t*t*t*t + b
    }
    func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t = t/d-1
        return -c*(t*t*t*t - 1) + b
    }
    func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        var t = t/(d/2)
        if (t < 1) {
            return c/2*t*t*t*t + b
        }
        t = t-2
        return -c/2*(t*t*t*t - 2) + b
    }
}

class Quad: Easing {
    func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t = t/d
        return c*t*t + b
    }
    func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t = t/d
        return -c * t*(t-2) + b
    }
    func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t = t/(d/2)
        if (t < 1) {
            return ((c/2)*(t*t)) + b
        }
        let tm = t - 1
        return -c/2 * (((tm-2)*(tm)) - 1) + b
    }
}

class Expo: Easing {
    func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b
    }
    func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        return (t==d) ? b+c : c * (-pow(2, -10 * t/d) + 1) + b
    }
    func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        var t = t
        if (t==0) {
            return b
        }
        if (t==d) {
            return b+c
        }
        t=t/(d/2)
        if (t < 1) {
            return c/2 * pow(2, 10 * (t - 1)) + b
        }
        t=t-1
        return c/2 * (-pow(2, -10 * t) + 2) + b
    }
}

class Elastic: Easing {
    func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        if t == 0 {
            return b
        }
        var t = t/d
        if t == 1 {
            return b + c
        }
        let p = d * 0.3
        let a = c
        let s = p / 4
        t = t - 1
        let postFix = a * pow(2, 10 * t)
        return -(postFix * sin((t * d - s) * (2 * Double.pi) / p)) + b
    }
    
    func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        if t == 0 {
            return b
        }
        let t = t/d
        if t == 1 {
            return b + c
        }
        let p = d * 0.3
        let a = c
        let s = p / 4
        return (a * pow(2, -10 * t) * sin((t * d - s) * (2 * Double.pi) / p) + c + b)
    }
    
    func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        if t == 0 {
            return b
        }
        var t = t/(d/2)
        if t == 2 {
            return b + c
        }
        let p = d * (0.3 * 1.5)
        let a = c
        let s = p / 4
        if t < 1 {
            t = t - 1
            let postFix = a * pow(2, 10 * t)
            return -0.5 * (postFix * sin((t * d - s) * (2 * Double.pi) / p)) + b
        }
        t = t - 1
        let postFix = a * pow(2, -10 * t)
        return postFix * sin((t * d - s) * (2 * Double.pi) / p) * 0.5 + c + b
    }
}

class Cubic: Easing {
    func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t = t / d
        return c*t*t*t + b
    }
    func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t=t/d-1
        return c*(t*t*t + 1) + b
    }
    func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        var t = t/(d/2)
        if (t < 1) {
            return c/2*t*t*t + b
        }
        t = t-2
        return c/2*(t*t*t + 2) + b
    }
}

class Circ: Easing {
    func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t = t / d
        return -c * (sqrt(1 - t*t) - 1) + b
    }
    func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t=t/d-1
        return c * sqrt(1 - t*t) + b
    }
    func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        var t = t/(d/2)
        if (t < 1) {
            return -c/2 * (sqrt(1 - t*t) - 1) + b
        }
        t = t-2
        return c/2 * (sqrt(1 - t*t) + 1) + b
    }
}

class Bounce: Easing {
    func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        return c - easeOut(t:d-t, b:0, c:c, d:d) + b
    }
    func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        var t = t / d
        if (t < (1/2.75)) {
            return c*(7.5625*t*t) + b
        } else if (t < (2/2.75)) {
            t = t - (1.5/2.75)
            return c*(7.5625*t*t + 0.75) + b
        } else if (t < (2.5/2.75)) {
            t = t - (2.25/2.75)
            return c*(7.5625*t*t + 0.9375) + b
        } else {
            t = t - (2.625/2.75)
            return c*(7.5625*(t)*t + 0.984375) + b
        }
    }
    func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        if (t < d/2) {
            return easeIn(t:t*2, b:0, c:c, d:d) * 0.5 + b
        } else {
            return easeOut(t:t*2-d, b:0, c:c, d:d) * 0.5 + c*0.5 + b
        }
    }
}

class Back: Easing {
    func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        let s = 1.70158
        let t = t / d
        return c*(t)*t*((s+1)*t - s) + b
    }
    func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        let s = 1.70158
        let t = t/d-1
        return c*(t*t*((s+1)*t + s) + 1) + b
    }
    func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        var s = 1.70158
        var t = t/(d/2)
        if (t < 1) {
            s = s * 1.525
            return c/2*(t*t*(((s)+1)*t - s)) + b
        }
        t = t - 2
        s = s * 1.525
        return c/2*((t)*t*(((s)+1)*t + s) + 2) + b
    }
}
