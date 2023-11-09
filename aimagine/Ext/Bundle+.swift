//
//  Bundle+.swift
//  aimagine
//
//  Created by son on 04/10/2023.
//

import Foundation

extension Bundle {
    func loadStylePresets() -> [StylePreset] {
        let file = "styles"
        
        guard let url = self.url(forResource: file, withExtension: "json") else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode([StylePreset].self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}
