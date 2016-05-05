//
//  SegueFromRight.swift
//  Q6IosClient
//
//  Created by yang wulong on 4/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SegueFromRight: UIStoryboardSegue
{
    override func perform()
    {
     
            var src: UIViewController = self.sourceViewController as! UIViewController
            var dst: UIViewController = self.destinationViewController as! UIViewController
            var transition: CATransition = CATransition()
            var timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.duration = 0.25
            transition.timingFunction = timeFunc
            transition.type = kCATransitionFromRight
            transition.subtype = kCATransitionFromLeft
            src.navigationController!.view.layer.addAnimation(transition, forKey: kCATransition)
            src.navigationController!.presentViewController(dst, animated: true, completion: nil)
        //popToViewController(dst, animated: false)
        //pushViewController(dst, animated: false)
        
    }
}