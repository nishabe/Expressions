//
//  Util.swift
//  Expressions
//
//  Created by Aneesh Abraham on 4/4/20.
//  Copyright © 2020 qaz. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func animate(layer: CALayer){
       let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = UIColor.gray.cgColor
        colorAnimation.duration = 0.7  // animation duration
        layer.add(colorAnimation, forKey: "ColorPulse")
    }
    
    func addBlinkingAnimation(view: UIView) {
        let key = "opacity"
        let animation = CABasicAnimation(keyPath: key)
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = 0.7
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.autoreverses = true
        animation.repeatCount = Float.greatestFiniteMagnitude
        view.layer.add(animation, forKey: key)
    }
}

