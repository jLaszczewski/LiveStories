//
//  SwipeBack.swift
//  Daimo
//
//  Created by Dhiān Ekatāl on 18.07.2017.
//  Copyright © 2017 myProject. All rights reserved.
//

import UIKit

class SwipeBack: NSObject {
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var sourceView: UIView!
    var destinationView: UIView!
    var sourceViewController: UIViewController!
    var destinationViewController: UIViewController!
    var window: UIWindow?
    let destinationViewXPosition = -UIScreen.main.bounds.width / 2
    var isSwipeBackBegan = false
    
    func backSwipe(gestureRecognizer: UIPanGestureRecognizer, sourceViewController: UIViewController) -> UIGestureRecognizerState {
        switch gestureRecognizer.state {
        case .began:
            self.sourceViewController = sourceViewController
            destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainStoryboard") as! LiveStoriesMainController
            
            sourceView = sourceViewController.view!
            destinationView = destinationViewController.view!
            
            screenWidth = sourceView.frame.width
            screenHeight = sourceView.frame.height
            
            sourceView.addShadow()
            sourceView.layer.shadowOffset = CGSize(width: -7, height: 3)
            sourceView.layer.shadowOpacity = 0.5
            
            destinationView.frame = CGRect(x: destinationViewXPosition, y: sourceView.frame.minY, width: sourceView.frame.width, height: sourceView.frame.height)
            
            window = UIApplication.shared.keyWindow
            window?.insertSubview(destinationView, belowSubview: sourceView)
            isSwipeBackBegan = true
        case .changed:
            if isSwipeBackBegan {
            let xTranslation = gestureRecognizer.translation(in: sourceView).x
            let destinationViewXOffset = (xTranslation / screenWidth) * (-destinationViewXPosition)
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                if self.sourceView.frame.offsetBy(dx: xTranslation, dy: 0.0).minX > 0 {
                    self.sourceView.frame = self.sourceView.frame.offsetBy(dx: xTranslation, dy: 0.0)
                    self.destinationView.frame = self.destinationView.frame.offsetBy(dx: destinationViewXOffset, dy: 0.0)
                    self.sourceView.layer.shadowOffset = CGSize(width: self.sourceView.layer.shadowOffset.width
                        + (xTranslation / self.screenWidth) * 7, height: self.sourceView.layer.shadowOffset.height)
                    self.sourceView.layer.shadowOpacity = self.sourceView.layer.shadowOpacity - Float(xTranslation / self.screenWidth) * 0.5
                }
            })
            
            gestureRecognizer.setTranslation(CGPoint.zero, in: sourceView)
            }
        case .ended, .cancelled:
            if isSwipeBackBegan {
            if sourceView.frame.origin.x >= 0.4 * screenWidth {
                
                gestureRecognizer.isEnabled = true
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                    self.sourceView.frame.origin.x = self.screenWidth
                    self.destinationView.frame.origin.x = 0
                    self.sourceView.backShadowAnimation(opacityFrom: self.sourceView.layer.shadowOpacity, offsetFrom:  self.sourceView.layer.shadowOffset, duration: 0.25)
                    
                }) { (finish) -> Void in
                    self.window = nil
                    customSegue(destinationViewController: self.destinationViewController)
                }
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                    self.sourceView.frame.origin.x = 0
                    self.destinationView.frame.origin.x = self.destinationViewXPosition
                }) { (finish) -> Void in
                    self.window = nil
                    self.destinationView.removeFromSuperview()
                }
            }
            }
        default:
            break
        }
        return gestureRecognizer.state
    }
}
