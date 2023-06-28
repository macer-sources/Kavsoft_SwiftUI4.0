//
//  LockScreenViewModel.swift
//  A_26_Lock Screen Depth Effect
//
//  Created by Kan Tao on 2023/6/28.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

class LockScreenViewModel: ObservableObject {
    
    @Published var pickedItem: PhotosPickerItem? {
        didSet {
            // MARK: Extracting Image
            extractImage()
        }
    }
    @Published var compressedImage: UIImage?
    
    
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
                })
            }
        }
    }
    
    
    // MARK: Scaling Properties
    @Published var scale: CGFloat = 1
    @Published var lastScale: CGFloat = 0
    
}


extension UIApplication {
    func screenSize() -> CGSize {
        guard let window = connectedScenes.first as? UIWindowScene else {return .zero}
        return window.screen.bounds.size
    }
}
