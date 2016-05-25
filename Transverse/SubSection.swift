//
//  SubSection.swift
//  Transverse
//
//  Created by Justin on 5/24/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

protocol SubSection: class {
    var difficulty: Float {get set}
    var length: Float {get}
    
    func copy() -> SubSection
    func setOrigin(x: Float, y: Float)
    func draw(renderType: RenderType)
    func refresh()
    func handleTouchMove(startX: Float, endX: Float, startY: Float, endY: Float) -> Bool
    func generate(width: Float, startX: Float, startY: Float)
    func generate(width: Float, startX: Float, startY: Float, length: Float)
    func flip()
    func empty()
}