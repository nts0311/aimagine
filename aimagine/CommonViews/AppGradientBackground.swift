//
//  AppGradientBackground.swift
//  aimagine
//
//  Created by son on 19/09/2023.
//

import SwiftUI

struct AppGradientBackground: View {
    var body: some View {
        VStack {
            GradientBg()
            GradientBg2()
        }
    }
    
    @ViewBuilder
    func GradientBg() -> some View {
        Rectangle()
          .foregroundColor(.clear)
          .background(
            EllipticalGradient(
              stops: [
                Gradient.Stop(color: Color(red: 0.58, green: 0.05, blue: 0.91).opacity(0.4), location: 0.0),
                Gradient.Stop(color: Color(red: 0.91, green: 0.05, blue: 0.55).opacity(0), location: 1.00),
              ],
              center: UnitPoint(x: 0.1, y: 0.1)
            )
          )
          
          .frame(width: UIScreen.screenWidth * 1)
          
    }
    
    @ViewBuilder
    func GradientBg2() -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .background(
                EllipticalGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.1, green: 0.03, blue: 0.95).opacity(0.3), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.91, green: 0.05, blue: 0.55).opacity(0), location: 1.00),
                    ],
                    center: UnitPoint(x: 1, y: 0.8)
                )
            )
            
            .frame(width: UIScreen.screenWidth)
        
            
    }
}

struct AppGradientBackground_Previews: PreviewProvider {
    static var previews: some View {
        AppGradientBackground()
    }
}
