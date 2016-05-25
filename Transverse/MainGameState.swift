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
    var rect: Rectangle?
    var roundedRect: RoundedRectangle?
    var circle: Circle?
    
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
        renderer.drawShape(circle!)
        renderer.drawShape(rect!)
        renderer.drawShape(roundedRect!)
    }
    
    func refreshDimensions(width: Float, height: Float, viewProjectionMatrix: GLKMatrix4) {
        if (self.width == width && self.height == height) {
            return
        }
        self.width = width
        self.height = height
        self.viewProjectionMatrix = viewProjectionMatrix
        text = Text()
        text?.setFont("FFF Forward")
        text?.text = "Transverse"
        text?.textSize = height/5
        text?.originX = 0
        text?.originY = 0
        text?.originZ = 0
        text?.refresh()
        line = Line()
        line?.width = 30
        line?.startPoint = (x: 0, y:0 , z:0)
        line?.endPoint = (x: width, y: height, z:0)
        line?.refresh()
        circle = Circle()
        circle?.centerX = width/2
        circle?.centerY = height/2
        circle?.centerZ = 0
        circle?.radius = height/5
        circle?.precision = 60
        circle?.refresh()
        rect = Rectangle()
        rect?.origin = (width/2 + height/4, height/2, 0)
        rect?.width = width/5
        rect?.height = height/5
        rect?.refresh()
        roundedRect = RoundedRectangle()
        roundedRect?.center = (width/2 - 3 * height / 5, height/2, 0)
        roundedRect?.height = height/2
        roundedRect?.width = width/4
        roundedRect?.precision = 60
        roundedRect?.cornerRadius = 40
        roundedRect?.refresh()
        renderer.matrix = viewProjectionMatrix
    }
}
