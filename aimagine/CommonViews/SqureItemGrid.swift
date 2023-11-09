//
//  SqureItemGrid.swift
//  aimagine
//
//  Created by son on 28/09/2023.
//

import SwiftUI

protocol SquareGridItem {
    var title: String? { get }
    var imageName: String? { get }
}

struct DefaultSquareGridItem: SquareGridItem {
    var title: String?
    var imageName: String?
}

struct SqureItemGrid: View {
    
    var items: [SquareGridItem]
    var itemPerRow: Int = 3
    
    @Binding var selectedIndex: Int?
    
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: itemPerRow)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(Array(items.enumerated()), id: \.element.title) { index, element in
                    build(element)
                        .onTapGesture {
                            selectedIndex = index
                        }
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder func build(_ item: SquareGridItem) -> some View {
        ZStack(alignment: .bottom) {
            Image(item.imageName ?? "")
                .resizable()
                .scaledToFit()
                .overlay {
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: .black.opacity(0.5), location: 0.00),
                            Gradient.Stop(color: .black.opacity(0), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.37, y: 1.01),
                        endPoint: UnitPoint(x: 0.38, y: 0.31)
                    )
                }
            
            Text(item.title ?? "")
                .font(Font.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom, 6)
        }
    }
    
}

var previewItems: [DefaultSquareGridItem] {
    //Array(repeating: DefaultSquareGridItem(title: "Anime", imageName: "anime"), count: 10)
    [
        DefaultSquareGridItem(title: "Anime1", imageName: "anime"),
        DefaultSquareGridItem(title: "Anime2", imageName: "anime"),
        DefaultSquareGridItem(title: "Anime", imageName: "anime"),DefaultSquareGridItem(title: "Anime4", imageName: "anime")
    ]
}

struct SqureItemGrid_Previews: PreviewProvider {
    static var previews: some View {
        SqureItemGrid(items: previewItems, selectedIndex: .constant(nil))
    }
}
