//
//  Section.swift
//  Transverse
//
//  Created by Justin on 5/24/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

protocol Section: class {
    var startX: Float {get}
    var startY: Float {get}
    var width: Float {get}
    var length: Float {get}
    var isSplit: Bool {get}
    var difficulty: Float {get set}
    
    func draw(matrix: GLKMatrix4, renderType: RenderType)
    func refresh()
    func empty()
    func handleTouchMove(startX: Float, endX: Float, startY: Float, endY: Float, rightSide: Bool) -> Bool
    func generate(startX: Float, width: Float, startY: Float)
}