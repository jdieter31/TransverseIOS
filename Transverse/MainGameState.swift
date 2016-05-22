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
    var image: Image
    
    init(viewController: GameViewController) {
        gameViewcontroller = viewController
        renderer = SolidRenderType()
        renderer.color = (0.5, 0.5, 0.5)
        renderer.alpha = 1
        image = Image()
    }
    
    func onDrawFrame() {
        let renderer: SolidRenderType = SolidRenderType()
        renderer.color = (0.5, 0.5, 0.5)
        renderer.alpha = 1
        renderer.matrix = viewProjectionMatrix
        renderer.drawImage(image)
    }
    
    func refreshDimensions(width: Float, height: Float, viewProjectionMatrix: GLKMatrix4) {
        self.width = width
        self.height = height
        self.viewProjectionMatrix = viewProjectionMatrix
        image = Image()
        image.vertices = [0, 0, 0, 0, height, 0, width, height, 0, width, 0, 0]
        image.drawOrder = [0, 1, 2, 0, 2, 3]
        image.uvCoordinates = [0, 0, 0, 1, 1, 1, 1, 0]
        image.textureHandle = Textures.fffForwardFontTexture
        renderer.matrix = viewProjectionMatrix
    }
}
