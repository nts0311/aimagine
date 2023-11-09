//
//  ContentView.swift
//  aimagine
//
//  Created by son on 04/09/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var imageGenerationStore = ImageGenerationStore()
    
    var body: some View {
       HomeSceen()
            .environmentObject(imageGenerationStore)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
