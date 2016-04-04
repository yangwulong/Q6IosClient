//
//  Q6Extension.swift
//  Q6IosClient
//
//  Created by yang wulong on 4/04/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation
import UIKit
extension CALayer {
    
    func addBorder(SelfWidth: CGFloat, edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        var border = CALayer()
    
        switch edge {
        case UIRectEdge.Top:
            border.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), thickness)
            break
        case UIRectEdge.Bottom:
            border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, SelfWidth, thickness)
            break
        case UIRectEdge.Left:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame))
            break
        case UIRectEdge.Right:
            border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame))
            break
        default:
            break
        }
        
        border.backgroundColor = color.CGColor;
        
        self.addSublayer(border)
    }
    
}