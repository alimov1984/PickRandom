//
//  ContentView.swift
//  PickRandom
//
//  Created by Андрей on 25.10.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \PersonData.name) private var persons: [PersonData] = []
    
    @State
    private var shouldRemovePickedName: Bool = true
    
    @State
    private var baseColorArray: [Color] = [.red, .green, .blue, .yellow, .orange, .purple, .pink,
                                           .teal, .indigo, .mint, .cyan, .gray]
    
    var body: some View {
        VStack {
            HeaderView()
            
            TabView(selection: .constant(0)) {
                NavigationStack {
                    WheelOfFortuneView(
                        shouldRemovePickedName: $shouldRemovePickedName,
                        baseColorArray: $baseColorArray)
                }
                .tabItem {
                    Label("Главная", systemImage: "house")
                }
                .tag(0)
                NavigationStack {
                    UserListView(shouldRemovePickedName: $shouldRemovePickedName,
                                 baseColorArray: $baseColorArray)
                }
                .tabItem {
                    Label("Участники", systemImage: "person.and.person")
                }
                .tag(1)
            }
            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
