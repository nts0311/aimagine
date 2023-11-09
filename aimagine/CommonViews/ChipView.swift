//
//  ChipView.swift
//  aimagine
//
//  Created by son on 23/10/2023.
//

import SwiftUI

protocol ChipItemData {
    var iconName: String? { get }
    var text: String { get }
}

struct ChipGroupView: View {
    
    var items: [ChipItemData]
    
    @Binding var selectedChipIndex: Int?
    
    init(items: [ChipItemData], selectedChipIndex: Binding<Int?> = .constant(nil)) {
        self.items = items
        self._selectedChipIndex = selectedChipIndex
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(items.indices) { index in
                    
                    let isChipSelected = (selectedChipIndex == index)
                    
                    ChipView(data: items[index], isSelected: isChipSelected)
                        .onTapGesture {
                            if selectedChipIndex == index {
                                selectedChipIndex = nil
                            } else {
                                selectedChipIndex = index
                            }
                        }
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct ChipView: View {
    
    var data: ChipItemData
    var isSelected: Bool
    
    var backgroundColor: Color {
        isSelected ? Color(red: 0.41, green: 0.54, blue: 1) : Color(red: 0.85, green: 0.85, blue: 0.85)
    }
    
    var textColor: Color {
        isSelected ? .white : .black
    }
    
    var body: some View {
        HStack(spacing: 16) {
            
            if let iconName = data.iconName {
                Image(iconName)
            }
                
            Text(data.text)
                .font(.body.bold())
                .foregroundColor(textColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Capsule().foregroundColor(backgroundColor))
        //.animation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 0))
    }
}

struct ChipView_Previews: PreviewProvider {
    static var previews: some View {
        ChipGroupView(items: [])
    }
}
