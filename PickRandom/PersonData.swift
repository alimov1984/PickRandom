import Foundation
import SwiftData
import SwiftUI
//
//  PersonData.swift
//  PickRandom
//
//  Created by Андрей on 25.10.2025.
//
@Model
class PersonData {
    var name: String
    var activated: Bool = true
  //  var color: Color = .black
    
//    @Transient // Don't store this property in SwiftData
//    var displayColor: Color {
//        // Convert hex string to Color using a helper extension
//        return Color(colorHex)
//    }
    
    init(name: String, activated: Bool)
    {
        self.name = name
        self.activated = activated
    }
}
