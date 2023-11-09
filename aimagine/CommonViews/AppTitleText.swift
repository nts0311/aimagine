//
//  AppTitleText.swift
//  aimagine
//
//  Created by son on 13/10/2023.
//

import SwiftUI

struct AppTitleText: View {
    
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(
                Font.system(size: 18)
                    .weight(.bold)
            )
    }
}

struct AppTitleText_Previews: PreviewProvider {
    static var previews: some View {
        AppTitleText("Title")
    }
}
