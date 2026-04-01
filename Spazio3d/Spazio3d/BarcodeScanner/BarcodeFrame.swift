//
//  BarcodeFrame.swift
//  Spazio3d
//
//  Created by Edis on 08/06/22.
//

import UIKit

public struct BarcodeFrame {
    
    public let corners:[CGPoint]
    public let cameraPreviewView: UIView
    
    public func draw(lineWidth: CGFloat = 1, lineColor: UIColor = UIColor.red, fillColor: UIColor = UIColor.clear) {
        
        let view = cameraPreviewView as! CameraPreview
        
        view.drawFrame(corners: corners,
            lineWidth: lineWidth,
            lineColor: lineColor,
            fillColor: fillColor)
    }
}
