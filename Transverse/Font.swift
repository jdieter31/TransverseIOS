//
//  Font.swift
//  Transverse
//
//  Created by Justin on 5/23/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

class Font : NSObject, NSXMLParserDelegate {
    var textureHandle: GLuint = 0
    var width: Int = 0
    var height: Int = 0
    var baseFontSize: Int = 0
    
    var chars: [Character]?
    var charHeights: [Int]?
    var charWidths: [Int]?
    var charX: [Int]?
    var charY: [Int]?
    var charXOffset: [Int]?
    var charYOffset: [Int]?
    var charXAdvance: [Int]?
    
    var kerningFirstChar: [Character] = [Character]()
    var kerningSecondChar: [Character] = [Character]()
    var kerningValue: [Int] = [Int]()
    
    var vertices: [Float]?
    var uvCoordinates: [Float]?
    var drawOrder: [GLushort]?
    
    var charIndex: Int = 0
    var kerningIndex: Int = 0
    
    init(urlOfXML: String, textureHandle: GLuint) {
        super.init()
        
        self.textureHandle = textureHandle
        let parser: NSXMLParser = NSXMLParser(contentsOfURL: NSURL(fileURLWithPath: urlOfXML))!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        charIndex = 0
        kerningIndex = 0
        if !success {
            print("Failed to load font")
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if (elementName == "chars") {
            let numOfChars: Int = Int(attributeDict["count"]!)!
            chars = [Character] (count: numOfChars, repeatedValue: " ")
            charHeights = [Int] (count: numOfChars, repeatedValue: 0)
            charWidths = [Int] (count: numOfChars, repeatedValue: 0)
            charX = [Int] (count: numOfChars, repeatedValue: 0)
            charY = [Int] (count: numOfChars, repeatedValue: 0)
            charXOffset = [Int] (count: numOfChars, repeatedValue: 0)
            charYOffset = [Int] (count: numOfChars, repeatedValue: 0)
            charXAdvance = [Int] (count: numOfChars, repeatedValue: 0)
        }
        if (elementName == "kernings") {
            let numOfKernings: Int = Int(attributeDict["count"]!)!
            kerningFirstChar = [Character] (count: numOfKernings, repeatedValue: " ")
            kerningSecondChar = [Character] (count: numOfKernings, repeatedValue: " ")
            kerningValue = [Int] (count: numOfKernings, repeatedValue: 0)
        }
        if (elementName == "common") {
            width = Int(attributeDict["scaleW"]!)!
            height = Int(attributeDict["scaleH"]!)!
        }
        if (elementName == "info") {
            baseFontSize = Int(attributeDict["size"]!)!
        }
        if (elementName == "char") {
            chars![charIndex] = Character(UnicodeScalar(Int(attributeDict["id"]!)!))
            charHeights![charIndex] = Int(attributeDict["height"]!)!
            charWidths![charIndex] = Int(attributeDict["width"]!)!
            charX![charIndex] = Int(attributeDict["x"]!)!
            charY![charIndex] = Int(attributeDict["y"]!)!
            charXOffset![charIndex] = Int(attributeDict["xoffset"]!)!
            charYOffset![charIndex] = Int(attributeDict["yoffset"]!)!
            charXAdvance![charIndex] = Int(attributeDict["xadvance"]!)!
            charIndex += 1
        }
        if (elementName == "kerning") {
            kerningFirstChar[kerningIndex] = Character(UnicodeScalar(Int(attributeDict["first"]!)!))
            kerningSecondChar[kerningIndex] = Character(UnicodeScalar(Int(attributeDict["second"]!)!))
            kerningValue[kerningIndex] = Int(attributeDict["amount"]!)!
            kerningIndex += 1
        }
    }
    
    //Uneeded XML Delegate methods
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print("Error: \(parseError.localizedDescription)")
    }
    
    func widthOfString(string: String, fontSize: Float) -> Float {
        var nonScaledWidth: Int = 0
        var prevChar: Character?
        for char in string.characters {
            let index: Int? = chars?.indexOf(char)
            if let index = index {
                if (index != string.characters.count - 1) {
                    nonScaledWidth += charXAdvance![index]
                } else {
                    nonScaledWidth += charWidths![index]
                }
                if let prevChar = prevChar {
                    nonScaledWidth += kerningForChars(prevChar, char2: char)
                }
            }
            prevChar = char
        }
        return Float(nonScaledWidth) * fontSize / Float(baseFontSize)
    }
    
    func heightOfString(string: String, fontSize: Float) -> Float {
        var nonScaledHeight: Int = 0
        for char in string.characters {
            let indexOfChar = chars?.indexOf(char)
            if (charHeights![indexOfChar!] > nonScaledHeight) {
                nonScaledHeight = charHeights![indexOfChar!]
            }
        }
        return Float(nonScaledHeight) * fontSize / Float(baseFontSize)
    }
    
    private func kerningForChars (char1: Character, char2: Character) -> Int {
        if (kerningFirstChar.count == 0) {
            return 0
        }
        for i in 0...(kerningFirstChar.count-1) {
            if (kerningFirstChar[i] == kerningSecondChar[i]) {
                return kerningValue[i]
            }
        }
        return 0
    }
    
    func calculateDataForString(string: String, fontSize: Float, originX: Float, originY: Float, originZ: Float) {
        vertices = [Float](count: string.characters.count*4*3, repeatedValue: 0)
        uvCoordinates = [Float](count: string.characters.count*4*2, repeatedValue: 0)
        drawOrder = [GLushort](count: string.characters.count*6, repeatedValue:0)
        
        var prevChar: Character?
        var xPosition: Int = 0
        var i: Int = 0
        for char in string.characters {
            let index = chars!.indexOf(char)
            
            uvCoordinates![i*4*2] = Float(charX![index!])/Float(width)
            uvCoordinates![i*4*2 + 1] = Float(charY![index!])/Float(height)
            
            uvCoordinates![i*4*2 + 2] = Float(charX![index!])/Float(width)
            uvCoordinates![i*4*2 + 3] = Float(charY![index!] + charHeights![index!])/Float(height)
            
            uvCoordinates![i*4*2 + 4] = Float(charX![index!] + charWidths![index!])/Float(width)
            uvCoordinates![i*4*2 + 5] = Float(charY![index!] + charHeights![index!])/Float(height)
            
            uvCoordinates![i*4*2 + 6] = Float(charX![index!] + charWidths![index!])/Float(width)
            uvCoordinates![i*4*2 + 7] = Float(charY![index!])/Float(height)
            
            drawOrder![i*6] = GLushort(i*4)
            drawOrder![i*6 + 1] = GLushort (i*4 + 1)
            drawOrder![i*6 + 2] = GLushort(i*4 + 2)
            drawOrder![i*6 + 3] = GLushort(i*4)
            drawOrder![i*6 + 4] = GLushort(i*4 + 2)
            drawOrder![i*6 + 5] = GLushort(i*4 + 3)
            
            if let prevChar = prevChar {
                xPosition += kerningForChars(prevChar, char2: char)
            }
            
            vertices![i*4*3] = Float(originX) + Float(xPosition + charXOffset![index!]) * fontSize / Float(baseFontSize)
            vertices![i*4*3 + 1] = Float(originY) + Float(charYOffset![index!]) * fontSize / Float(baseFontSize)
            vertices![i*4*3 + 2] = originZ
            
            vertices![i*4*3 + 3] = Float(originX) + Float(xPosition + charXOffset![index!]) * fontSize / Float(baseFontSize)
            vertices![i*4*3 + 4] = Float(originY) + Float(charYOffset![index!] + charHeights![index!]) * fontSize / Float(baseFontSize)
            vertices![i*4*3 + 5] = originZ
            
            vertices![i*4*3 + 6] = Float(originX) + Float(xPosition + charXOffset![index!] + charWidths![index!]) * fontSize / Float(baseFontSize)
            vertices![i*4*3 + 7] = Float(originY) + Float(charYOffset![index!] + charHeights![index!]) * fontSize / Float(baseFontSize)
            vertices![i*4*3 + 8] = originZ
            
            vertices![i*4*3 + 9] = Float(originX) + Float(xPosition + charXOffset![index!] + charWidths![index!]) * fontSize / Float(baseFontSize)
            vertices![i*4*3 + 10] = Float(originY) + Float(charYOffset![index!]) * fontSize / Float(baseFontSize)
            vertices![i*4*3 + 11] = originZ
            
            xPosition += charXAdvance![index!]
            prevChar = char
            i += 1
        }
    }
}