//
//  UIScreen+.swift
//  aimagine
//
//  Created by son on 22/09/2023.
//

import SwiftUI

public extension UIApplication {
    var currentWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
    
    static var statusBarHeight: CGFloat {
        UIApplication.shared.currentWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    static var safeArea: UIEdgeInsets {
        UIApplication.shared.currentWindow?.safeAreaInsets ?? .zero
    }
}
