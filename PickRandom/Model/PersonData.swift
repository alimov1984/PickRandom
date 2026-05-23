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
    
    init(name: String, activated: Bool)
    {
        self.name = name
        self.activated = activated
    }
    
    static let sampleData = [PersonData(name:"Дима", activated: true),
                             PersonData(name:"Андрей", activated: true),
                             PersonData(name:"Мария", activated: true),
                             PersonData(name:"Леонид", activated: true)]
    
}
