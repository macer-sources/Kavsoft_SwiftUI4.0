//
//  LockScreenViewModel.swift
//  A_26_Lock Screen Depth Effect
//
//  Created by Kan Tao on 2023/6/28.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

class LockScreenViewModel: ObservableObject {
    
    @Published var pickedItem: PhotosPickerItem? {
        didSet {
            // MARK: Extracting Image
            extractImage()
        }
    }
    @Published var compressedImage: UIImage?
    @Published var detectedPerson: UIImage?
    
    @Published var textRect: CGRect = .zero
    @Published var view: UIView = .init()
    @Published var placeTextAbove: Bool = false
    @Published var onLoad: Bool = false
    
    func extractImage() {
        if let pickedItem {
            Task {
                guard let imageData = try? await pickedItem.loadTransferable(type: Data.self) else {return }
                // MARK: Resizing Image To Photo size * 2
                // so that memory will be preserved
                let size = await UIApplication.shared.screenSize()
                let image = UIImage.init(data: imageData)?.sd_resizedImage(with: CGSize(width: size.width * 2, height: size.height * 2), scaleMode: .aspectFill)
                await MainActor.run(body: {
                    self.compressedImage = image
                    segmentPersonOnImage()
                })
            }
        }
    }
    
    
    // MARK: Scaling Properties
    @Published var scale: CGFloat = 1
    @Published var lastScale: CGFloat = 0
    
    
    // MARK: person segmentation using vision
    func segmentPersonOnImage() {
        guard let image = compressedImage?.cgImage else {
            return
        }
        // MARK: request
        let requet = VNGeneratePersonSegmentationRequest()
        // MARK: Set this to true only for testing in simulator
        requet.usesCPUOnly = true
        
        // MARK: task handler
        let task = VNImageRequestHandler(cgImage: image)
        do  {
            try task.perform([requet])
            if let result = requet.results?.first {
                let buffer = result.pixelBuffer
                maskWithOriginImage(buffer: buffer)
            }
        }catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    
    // MARK: it will give the mask/outline of the person present in the image
    // we need to mask it with the original image, in order to remove the background
    
    func maskWithOriginImage(buffer: CVPixelBuffer) {
        guard let cgimage = compressedImage?.cgImage else {return}
        let original = CIImage(cgImage: cgimage)
        let mask = CIImage(cvImageBuffer: buffer)
        
        // MARK: Scaling properties of the mask in order to fit perfectly
        let maskX = original.extent.width / mask.extent.width
        let maskY = original.extent.height / mask.extent.height
        
        let resizedMask = mask.transformed(by: CGAffineTransform(scaleX: maskX, y: maskY))
        
        //MARK: filter using core image
        let filter = CIFilter.blendWithMask()
        filter.inputImage = original
        filter.maskImage = resizedMask
        
        if let maskedImage = filter.outputImage {
            // MARK: Create UIImage
            let context = CIContext()
            guard let image = context.createCGImage(maskedImage, from: maskedImage.extent) else {
                return
            }
            
            // this is detected person image (抠出来的人像)
            self.detectedPerson = UIImage(cgImage: image)
            self.onLoad = true
        }
        
    }
    
    
    // MARK: Checking TextView Coordinates Color is Still white or not
    func verifyScreenColor() {
        // for more depth effect coverting it to mindY to minY
        // make sure it pointing out your text color
        let rgba = view.color(at: CGPoint.init(x: textRect.minX, y: textRect.minY + 5))
        
        // note since white color is 1,1,1,1
        // i'm directly comparing
        // if you're using another text color
        // then give those color components here 
        
        withAnimation {
            if rgba.0 == 1 && rgba.1 == 1 && rgba.2 == 1 && rgba.3 == 1 {
                placeTextAbove = false
            }else {
                placeTextAbove = true
            }
            
        }
    }
    
    
}


extension UIApplication {
    func screenSize() -> CGSize {
        guard let window = connectedScenes.first as? UIWindowScene else {return .zero}
        return window.screen.bounds.size
    }
}

extension UIView {
    func color(at point: CGPoint) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        var pixelData:[UInt8] = [0,0,0,0]
        
        guard let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorspace, bitmapInfo: bitmapInfo.rawValue) else {
            return (0,0,0,0)
        }
        
        context.translateBy(x: -point.x, y: -point.y)
        self.layer.render(in: context)
        
        let red = CGFloat(pixelData[0]) / 255
        let blue = CGFloat(pixelData[1]) / 255
        let green = CGFloat(pixelData[2]) / 255
        let alpha = CGFloat(pixelData[3]) / 255
        
        return (red, green, blue, alpha)
    }
}
