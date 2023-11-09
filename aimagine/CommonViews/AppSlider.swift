//
//  AppSlider.swift
//  aimagine
//
//  Created by son on 19/10/2023.
//

import SwiftUI

struct AppSlider: View {
    @Binding var value: Double
    
    var minValue: Double
    var maxValue: Double
    
    var step: Double = 1
    var showRange: Bool = true
    
    var leadingBottomText: String?
    var trailingBottomText: String?
    
    var body: some View {
        
        VStack {
            ZStack {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0, green: 0.5, blue: 0.95), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.61, green: 0, blue: 0.98), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: -0.05, y: 0),
                    endPoint: UnitPoint(x: 1.03, y: 0.85)
                )
                .mask(Slider(value: $value, in: minValue...maxValue, step: step))
                
                // Dummy replicated slider, to allow sliding
                Slider(value: $value, in: minValue...maxValue, step: step)
                    .opacity(0.05) // Opacity is the trick here.
                // .accentColor(.clear)
                // instead setting opacity,
                // setting clear color is another alternative
                // slider's circle remains white in this case
            }
            .fixedSize(horizontal: false, vertical: true)
            
            if let leadingBottomText, let trailingBottomText {
                HStack {
                    SliderLabel(text: leadingBottomText)
                    Spacer()
                    SliderLabel(text: trailingBottomText)
                }
            }
            
        }
    }
}

private struct SliderLabel: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            //.font(.footnote)
            .foregroundColor(.gray)
    }
}

struct AppSlider_Previews: PreviewProvider {
    static var previews: some View {
        AppSlider(value: .constant(50), minValue: 128, maxValue: 1024)
            .padding()
    }
}
