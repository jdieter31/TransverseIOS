//
//  FingerTrail.swift
//  Transverse
//
//  Created by Justin on 6/12/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit

protocol FingerTrail: class {
    func addTopPoint(x: Float, y: Float)
    func draw(matrix: GLKMatrix4)
}