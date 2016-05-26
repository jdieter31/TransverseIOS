//
//  DoubleSection.swift
//  Transverse
//
//  Created by Justin on 5/24/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit

class DoubleSection: Section {
    var startX: Float = 0
    var startY: Float = 0
    var width: Float = 0
    var length: Float = 0
    var isSplit: Bool = true
    var difficulty: Float = 0.5
    
    private var centerDivider: Rectangle?
    private var rightWall: Rectangle?
    private var leftWall: Rectangle?
    
    private var section1: SubSection?
    private var section2: SubSection?
    
    private var firstLeftGateLeft: Rectangle?
    private var firstLeftGateRight: Rectangle?
    private var firstRightGateLeft: Rectangle?
    private var firstRightGateRight: Rectangle?
    
    
    func draw(matrix: GLKMatrix4, renderType: RenderType) {
        renderType.matrix = matrix
        renderType.drawShape(centerDivider!)
        renderType.drawShape(leftWall!)
        renderType.drawShape(rightWall!)
        section1!.draw(renderType)
        section2!.draw(renderType)
        renderType.drawShape(firstLeftGateLeft!)
        renderType.drawShape(firstLeftGateRight!)
        renderType.drawShape(firstRightGateLeft!)
        renderType.drawShape(firstRightGateRight!)
    }
    
    func refresh() {
        leftWall?.refresh()
        rightWall?.refresh()
        centerDivider?.refresh()
        section1?.refresh()
        section2?.refresh()
        firstLeftGateLeft?.refresh()
        firstLeftGateRight?.refresh()
        firstRightGateLeft?.refresh()
        firstRightGateRight?.refresh()
    }
    
    func empty() {
        section1?.empty()
        section2?.empty()
    }
    
    func handleTouchMove(startX: Float, endX: Float, startY: Float, endY: Float, rightSide: Bool) -> Bool {
        if (firstLeftGateLeft!.lineSegmentCrosses(startX, startY: startY, endX: endX, endY: endY)
            || firstLeftGateRight!.lineSegmentCrosses(startX, startY: startY, endX: endX, endY: endY)
            || firstRightGateRight!.lineSegmentCrosses(startX, startY: startY, endX: endX, endY: endY)
            || firstRightGateLeft!.lineSegmentCrosses(startX, startY: startY, endX: endX, endY: endY)
            || rightWall!.lineSegmentCrosses(startX, startY: startY, endX: endX, endY: endY)
            || leftWall!.lineSegmentCrosses(startX, startY: startY, endX: endX, endY: endY)
            || centerDivider!.lineSegmentCrosses(startX, startY: startY, endX: endX, endY: endY)) {
            return true;
        }
        if (rightSide) {
            if (section2!.handleTouchMove(startX, endX: endX, startY: startY, endY: endY)) {
                return true;
            }
        } else {
            if (section1!.handleTouchMove(startX, endX: endX, startY: startY, endY: endY)) {
                return true;
            }
        }
        return false;
    }
    
    func generate(startX: Float, width: Float, startY: Float) {
        self.startX = startX;
        self.width = width;
        self.startY = startY;
        section1 = getSubSection();
        section1?.difficulty = difficulty;
        section1?.generate((width-45)/2, startX: startX + 15, startY: startY);
        length = section1!.length;
        
        if (Float(drand48()) < 0.7 - 0.5 * difficulty) {
            section2 = section1!.copy();
            if (Float(drand48()) < 0.5) {
                section1?.flip();
            }
            section2!.setOrigin(startX + 30 + (width-45)/2, y: startY);
        } else {
            section2 = getSubSection();
            section2?.difficulty = difficulty;
            section2!.generate((width-45)/2, startX: startX + 30 + (width-45)/2, startY: startY, length: length);
        }
        
        centerDivider = Rectangle();
        centerDivider!.origin = (startX + 15 + (width-45)/2, startY - length, 0);
        centerDivider!.width = 15;
        centerDivider!.height = length;
        leftWall = Rectangle();
        leftWall!.origin = (startX, startY - length, 0);
        leftWall!.width = 15;
        leftWall!.height = length;
        rightWall = Rectangle();
        rightWall!.origin = (startX + width - 15, startY - length, 0);
        rightWall!.width = 15;
        rightWall!.height = length;
        firstLeftGateLeft = Rectangle();
        firstLeftGateLeft!.origin = (startX + 15, startY - 15, 0);
        firstLeftGateLeft!.height = 15;
        firstLeftGateLeft!.width = ((width-45)/8);
        firstLeftGateRight = Rectangle();
        firstLeftGateRight!.origin = (3*(width-45)/8 + 15, startY - 15, 0);
        firstLeftGateRight!.height = 15;
        firstLeftGateRight!.width = ((width - 45)/8);
        firstRightGateLeft = Rectangle();
        firstRightGateLeft!.origin = ((width-45)/2 + 30, startY - 15, 0);
        firstRightGateLeft!.height = 15;
        firstRightGateLeft!.width = ((width - 45)/8);
        firstRightGateRight = Rectangle();
        firstRightGateRight!.origin = (30 + 7*(width-45)/8, startY - 15, 0);
        firstRightGateRight!.height = 15;
        firstRightGateRight!.width = ((width - 45)/8);
    }
    
    private func getSubSection() -> SubSection {
        let subSection: GateSubSection = GateSubSection()
        if (Float(drand48()) > 0.5) {
            subSection.inverted = true
        }
        return subSection
    }
}