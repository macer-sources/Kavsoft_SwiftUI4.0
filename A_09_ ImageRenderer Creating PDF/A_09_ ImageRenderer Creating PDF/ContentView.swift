//
//  ContentView.swift
//  A_09_ ImageRenderer Creating PDF
//
//  Created by Kan Tao on 2023/6/20.
//

import SwiftUI

struct ContentView: View {
    
    @State private var generatedImage: Image?
    @State private var generatedPDFURL: URL?
    
    @State private var showSheetShare = false
    
 
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack(alignment: .top) {
                
                // TODO: 针对小屏幕设备
                ViewThatFits {
                    
                    ReceiptView()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ReceiptView()
                    }
                }
                
                
                HStack(spacing: 20) {
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                    }

                    Spacer()
                    
                    // TODO: 分享
                    if let generatedImage {
                        ShareLink(item: generatedImage, preview: SharePreview.init("Payment Recepit")) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title3)
                        }
                    }
                    
                    // TODO: 这里swiftUI 有bug 无法调起
//                    if let generatedPDFURL {
//                        ShareLink(item: generatedPDFURL, preview: SharePreview.init("Payment Recepit")) {
//                            Image(systemName: "arrow.up.doc")
//                                .font(.title3)
//                        }
//                    }
                    
                    if let _ = generatedPDFURL {
                        Button {
                            showSheetShare.toggle()
                        } label: {
                            Image(systemName: "arrow.up.doc")
                                .font(.title3)
                        }

                    }
                    

                }
                .foregroundColor(.gray)
                .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    renderView(size: size)
                }
            }
        }
        .sheet(isPresented: $showSheetShare) {
            if let generatedPDFURL {
                ShareSheet(items: [generatedPDFURL])
            }
        }
        
    }
}



extension ContentView {
    @MainActor
    func renderView(size: CGSize) {
        let render = ImageRenderer(content: ReceiptView().frame(width: size.width,alignment: .center))
        if let image =  render.uiImage {
            generatedImage = Image(uiImage: image)
        }
        
        
        // MARK: Generating PDF
        guard let tempURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return
        }
        let renderURL = tempURL.appending(path: "\(UUID().uuidString).pdf")
        
        if let consumer = CGDataConsumer(url: renderURL as CFURL), let context = CGContext(consumer: consumer, mediaBox: nil, nil) {
            render.render { size, renderer in
                var mediaBox = CGRect.init(origin: .zero, size: size)
                // MARK: Drawing PDF
                context.beginPage(mediaBox: &mediaBox)
                renderer(context)
                context.endPDFPage()
                context.closePDF()
                
                // MARK: Updating PDF
                generatedPDFURL = renderURL
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
