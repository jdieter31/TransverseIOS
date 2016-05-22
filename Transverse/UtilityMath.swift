//
//  UtilityMath.swift
//  Transverse
//
//  Created by Justin on 5/21/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation

class UtilityMath {
    static func lineSegmentsCross(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float, x4: Float, y4: Float) -> Bool {
        // Return false if either of the lines have zero length
        if (x1 == x2 && y1 == y2 ||
            x3 == x4 && y3 == y4){
            return false;
        }
        // Fastest method, based on Franklin Antonio's "Faster Line Segment Intersection" topic "in Graphics Gems III" book (http://www.graphicsgems.org/)
        let ax: Float = x2-x1;
        let ay: Float = y2-y1;
        let bx: Float = x3-x4;
        let by: Float = y3-y4;
        let cx: Float = x1-x3;
        let cy: Float = y1-y3;
        
        let alphaNumerator: Float = by*cx - bx*cy;
        let commonDenominator: Float = ay*bx - ax*by;
        if (commonDenominator > 0){
            if (alphaNumerator < 0 || alphaNumerator > commonDenominator){
                return false;
            }
        }else if (commonDenominator < 0){
            if (alphaNumerator > 0 || alphaNumerator < commonDenominator){
                return false;
            }
        }
        let betaNumerator: Float = ax*cy - ay*cx;
        if (commonDenominator > 0){
            if (betaNumerator < 0 || betaNumerator > commonDenominator){
                return false;
            }
        }else if (commonDenominator < 0){
            if (betaNumerator > 0 || betaNumerator < commonDenominator){
                return false;
            }
        }
        if (commonDenominator == 0){
            // This code wasn't in Franklin Antonio's method. It was added by Keith Woodward.
            // The lines are parallel.
            // Check if they're collinear.
            let y3LessY1: Float = y3-y1;
            let collinearityTestForP3: Float = x1*(y2-y3) + x2*(y3LessY1) + x3*(y1-y2);   // see http://mathworld.wolfram.com/Collinear.html
            // If p3 is collinear with p1 and p2 then p4 will also be collinear, since p1-p2 is parallel with p3-p4
            if (collinearityTestForP3 == 0){
                // The lines are collinear. Now check if they overlap.
                if (x1 >= x3 && x1 <= x4 || x1 <= x3 && x1 >= x4 ||
                    x2 >= x3 && x2 <= x4 || x2 <= x3 && x2 >= x4 ||
                    x3 >= x1 && x3 <= x2 || x3 <= x1 && x3 >= x2){
                    if (y1 >= y3 && y1 <= y4 || y1 <= y3 && y1 >= y4 ||
                        y2 >= y3 && y2 <= y4 || y2 <= y3 && y2 >= y4 ||
                        y3 >= y1 && y3 <= y2 || y3 <= y1 && y3 >= y2){
                        return true;
                    }
                }
            }
            return false;
        }
        return true;
    }
}