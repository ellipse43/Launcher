//
//  UIButtonExtensions.swift
//  Launcher
//
//  Created by ellipse42 on 15/12/12.
//  Copyright © 2015年 ellipse42. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {

    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor)
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, forState: forState)
    }

}
