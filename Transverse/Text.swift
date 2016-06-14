//
//  Text.swift
//  Transverse
//
//  Created by Justin on 5/23/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit

class Text {
    
    init() {
        
    }
    
    static var fonts: [String : Font] = [String : Font]()
    
    var text: String?
    
    var originX: Float = 0
    var originY: Float = 0
    var originZ: Float = 0
    
    var font : Font?
    var textSize: Float = 0
    
    var textImage: Image?
    
    func refresh() {
        textImage = Image()
        textImage?.textureHandle = (font?.textureHandle)!
        font?.calculateDataForString(text!, fontSize: textSize, originX: originX, originY: originY, originZ: originZ)
        textImage?.uvCoordinates = font!.uvCoordinates!
        textImage?.drawOrder = font!.drawOrder!
        textImage?.vertices = font!.vertices!
    }
    
    func setFont(fontName: String) {
        font = Text.fonts[fontName]
    }
    
    func getWidth() -> Float {
        return font!.widthOfString(text!, fontSize: textSize)
    }
    
    func getHeight() -> Float {
        return font!.heightOfString(text!, fontSize: textSize)
    }
    
    static func loadFont(urlOfXML: String, textureHandle: GLuint, name: String) {
        Text.fonts[name] = Font(urlOfXML: urlOfXML, textureHandle:  textureHandle)
    }
        
}