//
//  OptionButton.swift
//  aimagine
//
//  Created by son on 19/09/2023.
//

import SwiftUI

struct OptionButton: View {
    
    var title: String? = nil
    let description: String
    let iconName: String
    var action: (() -> Void)? = nil
    
    var hasTitle: Bool {
        title != nil
    }
    
    var body: some View {
        
        Button {
            action?()
        } label: {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4.0) {
                    if let title {
                        Text(title)
                            .font(
                                Font.system(size: 14)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(hex: 0xD5D4D4))
                        
                    }
                    
                    Text(description)
                        .font(
                            Font.system(size: 16)
                                .weight(.semibold)
                        )
                        //.minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .foregroundColor(Color(hex: 0xF1F1F1))
                        .padding(.vertical, hasTitle ? 0 : 10)
                }.frame(idealWidth: .infinity)
                
                Spacer()//.frame(minWidth: 8, idealWidth: .infinity, maxHeight: 20)
                
                Image(iconName)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(BackgroundGradient())
            .background(Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.2))
            .cornerRadius(16)
            .addCommonBorder(lineWidth: 1)
        }
    }
    
    @ViewBuilder
    func BackgroundGradient() -> some View {
        EllipticalGradient(
            stops: [
                Gradient.Stop(color: .white.opacity(0.1), location: 0.00),
                Gradient.Stop(color: Color(red: 0.95, green: 0.95, blue: 0.95).opacity(0), location: 1.00),
            ],
            center: UnitPoint(x: 0, y: 0.09)
        )
    }
}

struct OptionButton_Previews: PreviewProvider {
    static var previews: some View {
        OptionButton(title: "nil", description: "Test", iconName: "ic_pen")
    }
}
