//
//  TextToImageResultScreen.swift
//  aimagine
//
//  Created by son on 05/10/2023.
//

import SwiftUI
import ACarousel

protocol ResultScreenData {
    var request: TextToImageRequest { get }
    var resultImages: [ImageResultDTO] { get }
}

struct TextToImageResultScreen: View {
    
    @EnvironmentObject var imageGenerationStore: ImageGenerationStore
    
    var items: [ImageResultDTO] {
        imageGenerationStore.latestResult?.images ?? []
    }
    
    var body: some View {
        
        var itemWidth: CGFloat {
            UIScreen.screenWidth * 0.86
        }
        
        ZStack(alignment: .top) {
            Color(red: 0.07, green: 0.06, blue: 0.11)
                .ignoresSafeArea()
            
           AppGradientBackground()
            
            VStack {
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(Color(hex: "#8F8F8F").opacity(0.2))
                
                
                ACarousel(items, spacing: 16,
                          sidesScaling: 0.8) {item in
                    Image(uiImage: item.uiImage)
                        .resizable()
                        .frame(width: itemWidth, height: itemWidth)
                        .cornerRadius(16)
                }
                .frame(height: itemWidth)
                
                AppButton(title: "Generate more")
                
                Spacer()
                    .frame(maxHeight: .infinity)
            }
            
        }
        .preferredColorScheme(.dark)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(title: "Result"))
    }
}

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var title: String
    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left") // set image here
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                Text(title)
            }
        }
    }
}

struct TextToImageResultScreen_Previews: PreviewProvider {
    static var previews: some View {
        
        let data = GeneratedImageResult(request: TextToImageRequest(data: ImageGenerationData()), images: [])
        
        TextToImageResultScreen()
    }
}
