//
//  BottomSheet.swift
//  aimagine
//
//  Created by son on 25/09/2023.
//

import SwiftUI

protocol BottomSheetAction {
    func dismiss()
}

enum SheetViewHeight: Equatable {
    case porpotional(CGFloat)
    case fixed(CGFloat)
    case dynamic
    case fullScreen
}

fileprivate let defaultHeight: CGFloat = UIScreen.screenHeight * 0.3


struct BottomSheet<Content: View>: View {
    var height: SheetViewHeight
    private let cornerRadius: CGFloat
    private let pullbarHeight: CGFloat = 10
    
    var heightValue: CGFloat {
        switch height {
        case .porpotional(let ratio):
            return UIScreen.screenHeight * ratio
        case .fixed(let height):
            return height
        case .dynamic:
            return contentHeight == 0 ? defaultHeight : contentHeight
            
        case .fullScreen:
            return UIScreen.screenHeight - UIScreen.statusBarHeight
        }
    }
    
    @Binding var isPresented: Bool
    @State private var contentHeight: CGFloat = 0
    
    @ViewBuilder var contentBuilder: (BottomSheetAction) -> Content
    
    init(
        isPresented: Binding<Bool>,
        height: SheetViewHeight = .fixed(defaultHeight),
        cornerRadius: CGFloat = 16.0,
        @ViewBuilder contentBuilder: @escaping (BottomSheetAction) -> Content
    ) {
        
        self._isPresented = isPresented
        self.height = height
        self.cornerRadius = cornerRadius
        self.contentBuilder = contentBuilder
        self._contentHeight = State(wrappedValue: heightValue)
    }
    
    
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 100, coordinateSpace: .global)
            .onChanged { value in
                let height = UIScreen.screenHeight - value.location.y
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    
                    if height > 0.9 * heightValue {
                        contentHeight = height
                    } else {
                        isPresented = false
                    }

                }
            }
            .onEnded { _ in  }
    }
    
    @ViewBuilder
    func GapView() -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 0)) {
                    isPresented.toggle()
                }
               
            }
    }
    
    @ViewBuilder
    func ContentView() -> some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(.clear)
                .frame(width: UIScreen.screenWidth, height: pullbarHeight)
                .contentShape(Rectangle())
                .gesture(dragGesture)
                .background(.clear)
                .zIndex(1)
            
            contentBuilder(self)
                .padding(.bottom, UIScreen.safeArea.bottom)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                })
        }
    }
    
    var body: some View {
        VStack {
            if isPresented {
                
                GapView()
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(.clear)
                    .frame(height: contentHeight)
                    .overlay {
                        ContentView()
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.spring(), value: isPresented)
                    .zIndex(1)
                    .onPreferenceChange(ViewHeightKey.self) {
                        if height != .dynamic {
                            return
                        }
                        
                        contentHeight = $0 + UIScreen.safeArea.bottom
                    }
                    .onDisappear {
                        contentHeight = heightValue
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .init(horizontal: .center, vertical: .bottom))
        .ignoresSafeArea(edges: .bottom)
        
    }
}

extension BottomSheet: BottomSheetAction {
    func dismiss() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isPresented = false
        }
    }
}
