//: Playground - noun: a place where people can play
//: Created by Yogesh Kohli
//: 05/02/2018

import UIKit

var str = "Hello, playground"



/*
 
 - AIM : to ocnvert UIImage to PixelBuffer which is used as input in CoreML model for prediction
 
 */


extension UIImage {
    public func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer?{
        var pixelBuffer : CVPixelBuffer? //pixelbuffer
        
        //attributes we want in our pixelbuffer
        let attributes = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]
        
        //status getting
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attributes as CFDictionary, &pixelBuffer)
        
        //checking if status = success else returning nil
        guard status == kCVReturnSuccess, let imageBuffer = pixelBuffer else { return nil }
        
        //Taking some room for memory
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        //getting image data
        let imageData = CVPixelBufferGetBaseAddress(imageBuffer)
        
        //context and setting properties
        guard let context = CGContext(data: imageData, width : width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(imageBuffer), space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else { return nil }
    
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1, y: -1)
        
        //pushing to context
        UIGraphicsPushContext(context)
        
        //drawing
        self.draw(in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        
        //popping
        UIGraphicsPopContext()
        
        //releasing memory
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        //returning
        return imageBuffer
    }
}

/*---------- USAGE -----------*/

//image
let image = UIImage(named: "image.png")

//Height and width will depend on your model input type image
let pixelBuffer = image?.pixelBuffer(width: 160, height: 160)



