//
//  Shape.swift
//  Transverse
//
//  Created by Justin on 5/21/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

protocol Shape {
    func refresh()
    func draw(verticeMatrixHandle: GLint)
}