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
        let src = self.sourceViewController
        let dst = self.destinationViewController
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransformMakeTranslation(-src.view.frame.size.width, 0)
////        //src.presentViewController(dst, animated: true, completion: nil)
////        UIView.animateWithDuration(0.25,
////                                   delay: 0.0,
////                                   options: UIViewAnimationOptions.CurveEaseInOut,
////                                   animations: {
////                                    dst.view.transform = CGAffineTransformMakeTranslation(0, 0)
////            },
////                                   completion: { finished in
////                                    src.presentViewController(dst, animated: false, completion: nil)
////            }
////      )
    }
}