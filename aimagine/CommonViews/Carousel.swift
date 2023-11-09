//
//  Carousel.swift
//  aimagine
//
//  Created by son on 12/10/2023.
//

import SwiftUI

struct Carousel<Items: RandomAccessCollection, ItemView: View>: View
    where Items.Element: Identifiable {
    
    var items: Items
    var itemBuilder:(Items.Element) -> ItemView
    var spacing: CGFloat
    var itemWidth: CGFloat
    
    @State private var screenDrag: CGFloat = 0
    @State private var activeItemIndex = 0
    @GestureState private var isDetectingLongPress = false
    
    var itemCount: Int {
        items.count
    }
    
    init(
        items: Items,
        spacing: CGFloat = 16,
        itemWidth: CGFloat,
        @ViewBuilder itemBuilder: @escaping (Items.Element) -> ItemView
    )  {
        self.items = items
        self.itemBuilder = itemBuilder
        self.spacing = spacing
        self.itemWidth = itemWidth
    }
    
    var body: some View {
        let totalSpacing = CGFloat(itemCount - 1) * spacing
        let totalItemWidth = itemWidth * CGFloat(itemCount) + totalSpacing
        
        let initalXOffsetLeft = (totalItemWidth - UIScreen.screenWidth) / CGFloat(2)
        
        let leftPadding = (UIScreen.screenWidth - itemWidth) / CGFloat(2)//hiddenCardWidth + spacing
        
        let movementPerItem = itemWidth + spacing
        
        let activeOffset = initalXOffsetLeft + leftPadding - (movementPerItem * CGFloat(activeItemIndex))
        
        let nextOffset = initalXOffsetLeft + leftPadding - (movementPerItem * CGFloat(activeItemIndex) + 1)

        
        var finalXOffset: CGFloat {
            if Float(activeOffset) != Float(nextOffset) {
                return activeOffset + screenDrag
            } else {
                return activeOffset
            }
        }
        
        let gesture = DragGesture()
            .updating($isDetectingLongPress) {currentState,_,_ in
                //screenDrag = currentState.translation.width
            }.onEnded {value in
                //screenDrag = 0

                if value.translation.width < -50 {
                    activeItemIndex += 1
                }
                
                if value.translation.width > 50 {
                    activeItemIndex -= 1
                }
            }
        
        HStack(alignment: .center, spacing: spacing) {
            ForEach(items) { item in
                itemBuilder(item)
                    .animation(.spring())
            }
        }
        .offset(x: activeOffset)
        .gesture(gesture)
    }
}

