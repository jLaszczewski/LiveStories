//
//  UIView+backShadowAnimation.swift
//  Daimo
//
//  Created by Dhiān Ekatāl on 18.07.2017.
//  Copyright © 2017 myProject. All rights reserved.
//

import UIKit

extension UIView {
    func backShadowAnimation(opacityFrom: Float, offsetFrom: CGSize, duration: CFTimeInterval) {
        let shadowOpacityAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        shadowOpacityAnimation.fromValue = opacityFrom
        shadowOpacityAnimation.toValue = 0.0
        shadowOpacityAnimation.duration = duration
        self.layer.add(shadowOpacityAnimation, forKey: "shadowOpacity")
        self.layer.shadowOpacity = 0.0
        
        let shadowOffsetAnimation = CABasicAnimation(keyPath: "shadowOffset")
        shadowOffsetAnimation.fromValue = offsetFrom
        shadowOffsetAnimation.toValue = CGSize(width: 0, height: 3)
        shadowOffsetAnimation.duration = duration
        self.layer.add(shadowOffsetAnimation, forKey: "shadowOffset")
        self.layer.shadowOffset =  CGSize(width: 0, height: 3)
    }
}
