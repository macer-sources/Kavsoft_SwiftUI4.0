//
//  ContentView.swift
//  A_26_Lock Screen Depth Effect
//
//  Created by Kan Tao on 2023/6/28.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject var viewModel = LockScreenViewModel()
    
    var body: some View {
        VStack {
            if let compressedImage = viewModel.compressedImage {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    Image(uiImage: compressedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size.width, height: size.height)
                        .overlay {
                            TimeView()
                                .environmentObject(viewModel)
                        }
                }
                
            }else {
                // MARK: Image Picker
                PhotosPicker(selection: $viewModel.pickedItem, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()) {
                    VStack(spacing: 10) {
                        Image(systemName: "plus.viewfinder")
                            .font(.largeTitle)
                        
                        Text("Add Image")
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            Button("Cancel") {
                withAnimation {
                    viewModel.compressedImage = nil
                }
            }
            .font(.caption)
            .foregroundColor(.primary)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background {
                Capsule()
                    .fill(.ultraThinMaterial)
            }
            .padding()
            .opacity(viewModel.compressedImage == nil ? 0 : 1)
        }
        
    }
}




// MARK: Time View
struct TimeView: View {
    @EnvironmentObject var viewModel: LockScreenViewModel
    var body: some View {
        HStack(spacing: 6) {
            Text(Date.now.convertToString(.hour))
                .font(.system(size: 95))
                .fontWeight(.semibold)
            
            VStack(spacing: 10) {
                Circle()
                    .fill(.white)
                    .frame(width: 15, height: 15)
                
                Circle()
                    .fill(.white)
                    .frame(width: 15, height: 15)
            }
            
            Text(Date.now.convertToString(.minute))
                .font(.system(size: 95))
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 100)
    }
}

enum DateFromat: String {
    case hour = "hh"
    case minute = "mm"
    case seconds = "ss"
}

extension Date {
    func convertToString(_ format: DateFromat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        
        return formatter.string(from: self)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
