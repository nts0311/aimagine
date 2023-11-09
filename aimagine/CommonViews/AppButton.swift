//
//  AppButton.swift
//  aimagine
//
//  Created by son on 13/10/2023.
//

import SwiftUI

struct AppButton: View {
    
    
    @Environment(\.isEnabled) var isEnabled
    
    var title: String
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action, label: {
            ButtonBackground()
        })
    }
    
    @ViewBuilder
    func ButtonBackground() -> some View {
        ZStack {
            if isEnabled {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0, green: 0.5, blue: 0.95), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.61, green: 0, blue: 0.98), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: -0.05, y: 0),
                    endPoint: UnitPoint(x: 1.03, y: 0.85)
                )
                .cornerRadius(16)
            } else {
                Color.gray.opacity(0.5)
                    .cornerRadius(16)
            }
            
            Text(title)
                .font(.title3.weight(.semibold))
                .tint(.white)
        }
        .frame(height: 60)
        .padding(.horizontal)
//        .overlay {
//            if !isEnabled {
//                Color.gray.opacity(0.5)
//            }
//        }
    }
}

struct AppButtonView: View {
    
    let title: String
    
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0, green: 0.5, blue: 0.95), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.61, green: 0, blue: 0.98), location: 1.00),
                ],
                startPoint: UnitPoint(x: -0.05, y: 0),
                endPoint: UnitPoint(x: 1.03, y: 0.85)
            )
            
            .cornerRadius(16)
            
            Text(title)
                .font(.title3.weight(.semibold))
                .tint(.white)
        }
        .frame(height: 60)
        .padding(.horizontal)
    }
}

struct AppButton_Previews: PreviewProvider {
    static var previews: some View {
        AppButton(title: "Button")
        AppButtonView(title: "Button")
    }
}


//struct AppButtonView_PreView: PreviewProvider {
//    static var previews: some View {
//
//    }
//}
