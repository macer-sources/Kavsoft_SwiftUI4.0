//
//  ShareSheet.swift
//  A_09_ ImageRenderer Creating PDF
//
//  Created by Kan Tao on 2023/6/20.
//

import SwiftUI
import UIKit


struct ShareSheet: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    var items:[Any]
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
}
