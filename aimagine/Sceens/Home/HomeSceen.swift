//
//  HomeSceen.swift
//  aimagine
//
//  Created by son on 04/09/2023.
//

import SwiftUI
import BottomSheet
import SwiftUIIntrospect

struct HomeSceen: View {
    @EnvironmentObject private var imageGeneratorStore: ImageGenerationStore
    
    @State private var showingStyleSheet = false
    @State private var showingEngineSheet = false
    @State private var isShowingResultScreen = false
    @State private var isShowingAdvancedSettingScreen = false
    
    @State private var isLoading = false
    @State private var data = ImageGenerationData()
    @State private var errorMessage: String? = nil
    
    private var disableGenerator: Bool {
        data.prompt.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color(red: 0.07, green: 0.06, blue: 0.11)
                    .ignoresSafeArea()
                
               AppGradientBackground()
                
                if isLoading {
                    LoadingView()
                } else {
                    VStack {
                        ScrollView {
                            VStack(alignment: .leading) {
                                PromptView()
                                OptionView()
                                BigButtonSection()
                            }
                        }
                        .frame(maxWidth: UIScreen.screenWidth, maxHeight: .infinity)
                    }
                }
                
                
                BottomSheet(isPresented: $showingStyleSheet, height: .fullScreen) {action in
                    StyleSelectionView(bottomSheetAction: action, selectedStyle: $data.style)
                }
            }
            .task {
                await initData()
            }
            .preferredColorScheme(.dark)
            .navigationTitle("AI Image")
            .navigationBarHidden(showingStyleSheet)
            .confirmationDialog("Select Engine", isPresented: $showingEngineSheet, titleVisibility: .visible) {
                ForEach(imageGeneratorStore.engines) {engine in
                    Button(engine.name ?? "") {
                        data.selectedEngine = engine
                    }
                }
            }
        }
        .accentColor(.white)
        
        
    }
    
    @ViewBuilder
    func NavBar() -> some View {
        HStack {
            Image(systemName: "line.3.horizontal")
            Text("AI Image")
                .font(.title2)
                .fontWeight(.semibold)
        }
        .padding()
        .frame( maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    func PromptView() -> some View {
        VStack(alignment: .leading) {
            AppTitleText("Enter prompt")
                .padding(.vertical, 8.0)
            ExpandabeTextBox(text: $data.prompt)
        }
        .padding(.horizontal)
        .padding(.top)
        .frame( maxWidth: .infinity)
    }
    
    @ViewBuilder
    func OptionView() -> some View {
        var engineName: String {
            data.selectedEngine?.shortName ?? "Add model"
        }
        
        var styleName: String {
            data.style?.name ?? "Add style"
        }
        
        VStack(alignment: .leading) {
            AppTitleText("Models and Styles")
                .padding()
            
            HStack(spacing: 16) {
                
                var buttonWidth: CGFloat {
                    (UIScreen.screenWidth - 48) / 2
                }
                
                OptionButton(title: "Models", description: engineName, iconName: "ic_pen") {
                    withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 0)) {
                        showingEngineSheet.toggle()
                    }
                }
                    .frame(width: buttonWidth)
                
                OptionButton(title: "Styles", description: styleName, iconName: "ic_add_round_solid") {
                    withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 0)) {
                        showingStyleSheet.toggle()
                    }
                }
                    .frame(width:buttonWidth)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: UIScreen.screenWidth)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom)
    }
    
    @ViewBuilder
    func BigButtonSection() -> some View {
        VStack {
            
            NavigationLink(isActive: $isShowingAdvancedSettingScreen,
            destination: {
                AdvancedSettingScreen(data: $data)
            }, label: {
                EmptyView()
            })
            
            OptionButton(description: "Advanced Settings", iconName: "ic_add_round_solid") {
                isShowingAdvancedSettingScreen = true
            }
                .padding(.horizontal, 16)
        }
        
        
        VStack {
            NavigationLink(destination: TextToImageResultScreen(), isActive: $isShowingResultScreen) { EmptyView() }
            
            AppButton(title: "Generate") {
                beginGeneration()
            }
            .disabled(disableGenerator)
            .padding(.top)
        }
    }
}

extension HomeSceen {
    
    func initData() async {
        guard imageGeneratorStore.engines.isEmpty else {
            return
        }
        
        isLoading = true
        do {
            try await imageGeneratorStore.loadEngine()
            data.selectedEngine = imageGeneratorStore.defaultEngine
        } catch {
            errorMessage = "Cannot load engine!"
        }
        
        isLoading = false
    }
    
    func beginGeneration() {
        Task {
            do {
                isLoading = true
                try await imageGeneratorStore.generateImages(from: data)
                isLoading = false
                data = ImageGenerationData()
                isShowingResultScreen = true
            } catch {
                errorMessage = "An error occured. Please try again later."
            }
        }
    }
    
}

//struct HomeSceen_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeSceen()
//    }
//}
