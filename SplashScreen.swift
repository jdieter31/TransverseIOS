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
        print("Pushing next view")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("mainViewController")
        self.presentViewController(vc, animated: true, completion: nil)    }
}