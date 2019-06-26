//
//  QRCode.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 6/21/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit

class QRCode: UIView {

    let myString = "003S0000017xFExIAM"
    // Get data from the string
    let data = myString.data(using: String.Encoding.ascii)
    // Get a QR CIFilter
    guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
    // Input the data
    qrFilter.setValue(data, forKey: "inputMessage")
    // Get the output image
    guard let qrImage = qrFilter.outputImage else { return }
    // Scale the image
    let transform = CGAffineTransform(scaleX: 10, y: 10)
    let scaledQrImage = qrImage.transformed(by: transform)
    // Invert the colors
    guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return }
    colorInvertFilter.setValue(scaledQrImage, forKey: "inputImage")
    guard let outputInvertedImage = colorInvertFilter.outputImage else { return }
    // Replace the black with transparency
    guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return }
    maskToAlphaFilter.setValue(outputInvertedImage, forKey: "inputImage")
    guard let outputCIImage = maskToAlphaFilter.outputImage else { return }
    // Do some processing to get the UIImage
    let context = CIContext()
    guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return }
    let processedImage = UIImage(cgImage: cgImage)
    

}
