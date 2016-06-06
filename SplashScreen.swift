//
//  SplashScreen.swift
//  Transverse
//
//  Created by Justin on 5/30/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation

class SplashScreen : UIViewController {
    override func viewDidLoad() {
        self.performSelector(#selector(SplashScreen.loadNextView), withObject: nil, afterDelay: 3.0)
    }
    
    func loadNextView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("mainViewController")
        UnityAds.sharedInstance().startWithGameId("1069657", andViewController: vc)
        self.presentViewController(vc, animated: true, completion: nil)    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}