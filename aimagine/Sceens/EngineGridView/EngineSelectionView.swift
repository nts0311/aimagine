//
//  EngineSelection.swift
//  aimagine
//
//  Created by son on 27/09/2023.
//

import SwiftUI

struct EngineSelectionView: View {
    
    private let service = StabilityAIService()
    
    @State private var engines: [Engine] = []
    @Binding var selectedEngine: Engine?
    
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color(red: 0.07, green: 0.06, blue: 0.11)
                .ignoresSafeArea()
            
            AppGradientBackground()
            
            
//            VStack {
//                Text("Select generating engine")
//                    .font(.title3)
//                    .foregroundColor(.black)
//                    
//                
//                if !engines.isEmpty {
//                    List(engines) { engine in
//                        Text(engine.name ?? "")
//                            .foregroundColor(.black)
//                            .listRowBackground(Color.white)
//                    }
//                    .listStyle(.plain)
//                } else {
//                    ProgressView("Loading")
//                        .tint(.black)
//                }
//                
//            }
//            .background(.white)
//            .foregroundColor(.white)
//            .padding()
        }
        
        
        .task {
            do {
                //self.engines = try await StabilityAIService.getListEngines()
            } catch {
                print(error)
            }
        }
    }
}

//struct EngineSelection_Previews: PreviewProvider {
//    static var previews: some View {
//        EngineSelection()
//    }
//}
