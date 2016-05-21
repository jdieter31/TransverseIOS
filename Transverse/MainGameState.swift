//
//  MainGameState.swift
//  Transverse
//
//  Created by Justin on 5/21/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

class MainGameState {
    var gameViewcontroller: GameViewController
    
    init(viewController: GameViewController) {
        gameViewcontroller = viewController
    }
    
    func onDrawFrame() {
        
    }
    
    func refreshDimensions(width: Float, height: Float, viewProjectionMatrix: GLKMatrix4) {
        
    }
}
