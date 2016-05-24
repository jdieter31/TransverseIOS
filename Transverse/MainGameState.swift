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
    
    var width: Float = 0;
    var height: Float = 0;
    
    var viewProjectionMatrix: GLKMatrix4? = nil
    
    var renderer: SolidRenderType
    var text: Text?
    var line: Line?
    
    init(viewController: GameViewController) {
        gameViewcontroller = viewController
        renderer = SolidRenderType()
        renderer.color = (0.5, 0.5, 0.5)
        renderer.alpha = 1
    }
    
    func onDrawFrame() {
        let renderer: SolidRenderType = SolidRenderType()
        renderer.color = (0.5, 0.5, 0.5)
        renderer.alpha = 1
        renderer.matrix = viewProjectionMatrix
        if let text = text {
            renderer.drawText(text)
        }
        if let line = line {
            renderer.drawAlphaShape(line)
        }
    }
    
    func refreshDimensions(width: Float, height: Float, viewProjectionMatrix: GLKMatrix4) {
        self.width = width
        self.height = height
        self.viewProjectionMatrix = viewProjectionMatrix
        text = Text()
        text?.setFont("FFF Forward")
        text?.text = "Transverse"
        text?.textSize = height/2
        text?.originX = 0
        text?.originY = 0
        text?.originZ = 0
        text?.refresh()
        line = Line()
        line?.width = 30
        line?.startPoint = (x: 0, y:0 , z:0)
        line?.endPoint = (x: width, y: height, z:0)
        line?.refresh()
        renderer.matrix = viewProjectionMatrix
    }
}
