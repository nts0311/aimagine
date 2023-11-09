//
//  ExpandabeTextBox.swift
//  aimagine
//
//  Created by son on 04/09/2023.
//

import SwiftUI
import SwiftUIIntrospect

struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

struct ExpandabeTextBox: View {
    var minHeight: CGFloat = 100
    
    @Binding var text: String
    @State private var textEditorHeight : CGFloat = 20
    
    var body: some View {
        VStack(alignment: .trailing) {

            ZStack {
                Text(text)
                    .foregroundColor(.clear)
                    .padding(14)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewHeightKey.self,
                                               value: $0.frame(in: .local).size.height)
                    })
                TextEditor(text: $text)
                    .autocorrectionDisabled(true)
                    .frame(height: max(minHeight, textEditorHeight))
                    .introspect(.textEditor, on: .iOS(.v14, .v15, .v16, .v17)) { textView in
                        textView.backgroundColor = .clear
                    } 
            }.onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
            
            
            HStack {
                Image(systemName: "clock")
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 4))
        
        }
        .padding(4)
        .addCommonBorder()
    }
}
