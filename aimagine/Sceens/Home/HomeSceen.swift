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
    @State private var showingStyleSheet = false
    @State private var showingEngineSheet = false
    @State private var isShowingResultScreen = false
    @State private var isShowingAdvancedSettingScreen = false
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color(red: 0.07, green: 0.06, blue: 0.11)
                    .ignoresSafeArea()
                
               AppGradientBackground()
                
                if viewModel.isLoading {
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
                    StyleSelectionView(bottomSheetAction: action, selectedStyle: $viewModel.data.style)
                }
            }
            .task {
                await viewModel.loadEngineAsync()
            }
            .preferredColorScheme(.dark)
            .navigationTitle("AI Image")
            .navigationBarHidden(showingStyleSheet)
            .confirmationDialog("Select Engine", isPresented: $showingEngineSheet, titleVisibility: .visible) {
                ForEach(viewModel.engines) {engine in
                    Button(engine.name ?? "") {
                        viewModel.data.selectedEngine = engine
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
            ExpandabeTextBox(text: $viewModel.data.prompt)
        }
        .padding(.horizontal)
        .padding(.top)
        .frame( maxWidth: .infinity)
    }
    
    @ViewBuilder
    func OptionView() -> some View {
        var engineName: String {
            viewModel.data.selectedEngine?.shortName ?? "Add model"
        }
        
        var styleName: String {
            viewModel.data.style?.name ?? "Add style"
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
                AdvancedSettingScreen(data: $viewModel.data)
            }, label: {
                EmptyView()
            })
            
            OptionButton(description: "Advanced Settings", iconName: "ic_add_round_solid") {
                isShowingAdvancedSettingScreen = true
            }
                .padding(.horizontal, 16)
        }
        
        
        VStack {
            NavigationLink(destination: TextToImageResultScreen(), isActive: $viewModel.isShowingResultScreen) { EmptyView() }
            
            AppButton(title: "Generate!") {
                viewModel.beginGeneration()
            }
            .disabled(viewModel.disableGenerator)
            .padding(.vertical)
        }
    }
}

//struct HomeSceen_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeSceen()
//    }
//}
