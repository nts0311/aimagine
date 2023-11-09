//
//  StylePreset.swift
//  aimagine
//
//  Created by son on 03/10/2023.
//

import Foundation

struct StylePreset: Codable, Equatable {
    let code: String
    let name: String
}

extension StylePreset: SquareGridItem {
    var title: String? {
        name
    }
    
    var imageName: String? {
        code
    }
}
