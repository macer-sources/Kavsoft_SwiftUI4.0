//
//  Extensions.swift
//  A_06_Apple Maps Bottom Sheet
//
//  Created by work on 6/17/23.
//

import Foundation
import SwiftUI


// MARK: Custom View Extensions

// MARK: Custom Bottom Sheet Extracting From Navite SwiftUI

extension View {
    @ViewBuilder
    func bottomSheet<Content: View>(
        presentationDetents: Set<PresentationDetent>,
        isPresented: Binding<Bool>,
        dragIndicator: Visibility = .visible,
        sheetCornerRadius: CGFloat?,
        largestUndimmedIdentifier: UISheetPresentationController.Detent.Identifier = .large,
        isTransparentBG: Bool = false,
        interactiveDisabled: Bool = true,
        @ViewBuilder content: @escaping () -> Content,
        onDismiss:@escaping () -> Void = {}
    ) -> some View {
        /**
                TODO: 推荐使用 16.4 之后的方式，
         */
        self
            .sheet(isPresented: isPresented) {
                onDismiss()
            } content: {
                content()
//                    .presentationBackground(.white)// 16.4 之后 sheet 背景色
                    .presentationDetents(presentationDetents)
                    .presentationDragIndicator(dragIndicator)
                    .interactiveDismissDisabled(interactiveDisabled)
//                    .presentationCornerRadius(sheetCornerRadius) // 16.4 之后设置圆角
//                    .presentationBackgroundInteraction(.enabled) // 16.4 之后 启用后台交互
                    .onAppear {
                        // 16.4 之前的方式，启用后台交互，这里延迟 0.2 秒，不然 controller获取到位 nil，导致设置失败
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { //
                            guard let windows = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows else {
                                return
                            }
                            
                            if let controller = windows.first?.rootViewController?.presentedViewController, let sheet = controller.presentationController as? UISheetPresentationController {
                                controller.presentingViewController?.view.tintAdjustmentMode = .normal  // TODO: 不写这一句，nav bar button 是灰色的
                                sheet.largestUndimmedDetentIdentifier = largestUndimmedIdentifier
                                sheet.preferredCornerRadius = sheetCornerRadius // 16.4 之前。设置圆角
                                
                                // TODO: 16.4 之后都有直接可以设置方法 presentationBackground
                                if isTransparentBG {
                                    controller.view.backgroundColor = .clear
                                }
                                
                            }
                        }
                        
                        debugPrint("")
                    }
            }

    }
}
