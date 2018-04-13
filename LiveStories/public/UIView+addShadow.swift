//
//  UIView+addShadow.swift
//  Daimo
//
//  Created by Dhiān Ekatāl on 06.07.2017.
//  Copyright © 2017 myProject. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: -1, height: 3)
    }
}
