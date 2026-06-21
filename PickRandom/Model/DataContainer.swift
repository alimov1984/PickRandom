import SwiftData
import SwiftUI

//
//  DataContainer.swift
//  PickRandom
//
//  Created by Андрей on 01.05.2026.
//

@MainActor
@Observable
class DataContainer {
    static let sampleContainer = DataContainer(includeSampleData: true)
    static let mainContainer = DataContainer(includeSampleData: false)
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    private init(includeSampleData: Bool = false) {
        let schema = Schema([
            PersonData.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: includeSampleData)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            if includeSampleData {
                insertSampleData()
                try context.save()
            }
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func insertSampleData() {
        for person in PersonData.sampleData {
            context.insert(person)
        }
    }
}

extension View {
    func sampleDataContainer() -> some View {
        self
            .environment(DataContainer.sampleContainer)
            .modelContainer(DataContainer.sampleContainer.modelContainer)
    }
}
