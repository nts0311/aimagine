//
//  View+.swift
//  aimagine
//
//  Created by son on 19/09/2023.
//

import SwiftUI

extension View {
    
    func addCommonBorder(lineWidth: CGFloat = 2) -> some View {
        self.border(color: Color.borderCorlor, lineWidth: lineWidth)
    }
    
    func border(color: Color, lineWidth: CGFloat) -> some View {
        self.overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.borderCorlor, lineWidth: 2)
        }
    }
    
}
