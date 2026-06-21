//
//  PickRandomApp.swift
//  PickRandom
//
//  Created by Андрей on 25.10.2025.
//

import SwiftUI
import SwiftData

@main
struct PickRandomApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environment(DataContainer.mainContainer)
        }.modelContainer(DataContainer.mainContainer.modelContainer)
    }
}
