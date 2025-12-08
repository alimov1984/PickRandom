//
//  ColorExtension.swift
//  PickRandom
//
//  Created by Андрей on 22.11.2025.
//
import SwiftUI

extension Color {
    func toHexString() -> String {
        guard let components = self.cgColor?.components, components.count >= 3 else {
            return "#FFFFFF" // Default to white or handle error as appropriate
        }
        
        let r = components[0]
        let g = components[1]
        let b = components[2]
        
        let hexString = String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        return hexString
    }
}
