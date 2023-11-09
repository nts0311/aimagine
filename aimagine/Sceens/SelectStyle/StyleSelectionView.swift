//
//  StyleSelectionView.swift
//  aimagine
//
//  Created by son on 03/10/2023.
//

import SwiftUI

struct StyleSelectionView: View {
    
    var bottomSheetAction: BottomSheetAction? = nil
    
    @State private var searchText: String = ""
    @Binding var selectedStyle: StylePreset?
    
    private let stylePresets = Bundle.main.loadStylePresets()
    
    var displayPreset: [StylePreset] {
        
        if searchText.isEmpty {
            return stylePresets
        }
        
        return stylePresets.filter { preset in
            preset.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    var selectedStyleBinding: Binding<Int?> {
        Binding(
            get: {
                guard let selectedStyle else { return nil }
                return stylePresets.firstIndex { selectedStyle == $0 }
            },
            set: {selectedIndex in
                guard let selectedIndex else {
                    return
                }
                selectedStyle = stylePresets[selectedIndex]
            }
        )
    }
    
    var body: some View {
        ZStack(alignment: .top) {

            Color(hex: "#292929")
                .cornerRadius(16)
                .ignoresSafeArea(edges: .bottom)
            
            VStack {
                SearchBarHeader(title: "Select Style", leftButtonAction: {
                    bottomSheetAction?.dismiss()
                }, searchText: $searchText)
                SqureItemGrid(items: displayPreset, selectedIndex: selectedStyleBinding)
            }.zIndex(1)
        }
        .onChange(of: selectedStyle) {newValue in
            if let newValue {
                bottomSheetAction?.dismiss()
            }
        }
        //.fixedSize(horizontal: false, vertical: true)
        
    }
}

struct StyleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        StyleSelectionView(selectedStyle: .constant(nil))
    }
}
