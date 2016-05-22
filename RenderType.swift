//
//  RenderType.swift
//  Transverse
//
//  Created by Justin on 5/21/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES


protocol RenderType {
    func drawShape(shape: Shape)
    func drawAlphaShape(line: AlphaShape)
    func drawImage(image: Image)
    var alpha: Float {get set}
    var matrix: GLKMatrix4? {get set}
}