//
//  SearchBarHeader.swift
//  aimagine
//
//  Created by son on 04/10/2023.
//

import SwiftUI

struct SearchBarHeader: View {
    
    var title: String
    var leftButtonAction: (() -> Void)?
    
    @State private var isShowingSearch = false
    @Binding var searchText: String
    
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    leftButtonAction?()
                }
                .foregroundColor(.white.opacity(0.6))
                .contentShape(Rectangle())
                
                Spacer()
                
                Button(action: {
                    isShowingSearch.toggle()
                }, label: {
                    Image(systemName: "sparkle.magnifyingglass")
                        .tint(.white)
                        .contentShape(Rectangle())
                })
                
            }
            .overlay {
                Text(title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
            
            if isShowingSearch {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .tint(.white)
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.4))
                        .cornerRadius(4)
                        .foregroundColor(.white)
                }
                
            }
        }
        
        .padding()
        
    }
}
struct SearchBarHeader_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarHeader(title: "Khum", searchText: .constant(""))
    }
}
