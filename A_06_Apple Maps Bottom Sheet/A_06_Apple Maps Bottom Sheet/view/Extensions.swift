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
        dragVisibility: Visibility = .visible,
        sheetCornerRadius: CGFloat?,
        largestUndimmedIdentifier: UISheetPresentationController.Detent.Identifier = .large,
        isTransparentBG: Bool = false,
        interactiveDisabled: Bool = true,
        @ViewBuilder content: @escaping () -> Content,
        onDismiss:@escaping () -> Void
    ) -> some View {
        
        self
            .sheet(isPresented: isPresented) {
                onDismiss()
            } content: {
                content()
                    .presentationDetents(presentationDetents)
                    .presentationDragIndicator(dragVisibility)
                    .interactiveDismissDisabled(interactiveDisabled)
                    .onAppear {

                    }
            }

    }
}
