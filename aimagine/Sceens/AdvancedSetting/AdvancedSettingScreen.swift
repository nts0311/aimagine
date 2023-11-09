//
//  AdvancedSettingScreen.swift
//  aimagine
//
//  Created by son on 05/10/2023.
//

import SwiftUI

struct AdvancedSettingScreen: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var data: ImageGenerationData
    
    @StateObject private var viewModel: AdvancedSettingViewModel
    
    init(data: Binding<ImageGenerationData>) {
        self._data = data
        let wrappedVM = AdvancedSettingViewModel(data: data.wrappedValue)
        self._viewModel = StateObject(wrappedValue: wrappedVM)
    }
    
    var negativePromptBinding: Binding<String> {
        Binding(get: {
            data.negativePrompt ?? ""
        }, set: { newValue, transaction in
            data.negativePrompt = newValue
        })
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.07, green: 0.06, blue: 0.11)
                .ignoresSafeArea()
            
           AppGradientBackground()
            
            ScrollView {
                VStack(alignment: .leading) {
                    AppTitleText("Negative Prompt")
                        .padding(.horizontal)
                        .padding(.top)
                    
                    //Text("\(viewModel.width)")

                    TextField("Don't include...", text: negativePromptBinding)
                        .padding()
                        .addCommonBorder()
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    AppTitleText("Aspect Ratio")
                        .padding(.horizontal)
                    
                    ChipGroupView(items: viewModel.presetSizes, selectedChipIndex: $viewModel.selectedPresetIndex)
                        .padding(.horizontal)
                    
                    ImageSizeInputView()
                        .padding(.vertical)
                    
                    AppTitleText("CFG Scale")
                        .padding(.horizontal)
                    
                    AppSlider(value: $viewModel.data.cfgScale, minValue: 0.0, maxValue: 35.0, leadingBottomText: "Better Quality", trailingBottomText: "Match Prompt")
                        .padding()
                    
                    AppTitleText("Step")
                        .padding(.horizontal)
                    
                    AppSlider(value: $viewModel.data.steps, minValue: 10, maxValue: 150, leadingBottomText: "Faster Processing", trailingBottomText: "Better Quality")
                        .padding()
                    
                    AppButton(title: "Save") {
                        self.data = viewModel.data
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(viewModel.hasError)
                    
                }
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        //.navigationBarItems(leading: BackButton(title: "Advanced Settings"))
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    func ImageSizeInputView() -> some View {
        VStack(alignment: .leading) {
            AppTitleText("Image size")
                .padding(.horizontal)
            
            HStack(spacing: 16) {
                
                TextField("Width", value: $viewModel.data.width, formatter: NumberFormatter())
                    .padding()
                    .addCommonBorder()
                    .keyboardType(.numberPad)
                
                TextField("Height", value: $viewModel.data.height, formatter: NumberFormatter())
                    .padding()
                    .addCommonBorder()
                    .keyboardType(.numberPad)
                
            }
            .padding(.horizontal)
            
            if let errorMsg = viewModel.errorMessage {
                Text(errorMsg)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
    
}

//struct AdvancedSettingScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        AdvancedSettingScreen(data: .constant(ImageGenerationData()))
//    }
//}
