//
//  ContentView.swift
//  PickRandom
//
//  Created by Андрей on 25.10.2025.
//

import SwiftUI
import SwiftData
import OSLog

struct ContentView: View {
    @Query(sort: \PersonData.name) private var persons: [PersonData] = []
    
    @State private var shouldRemovePickedName: Bool = true
    
    @State
    private var baseColorArray: [Color] = [.red, .green, .blue, .yellow, .orange, .purple, .pink,
                                           .teal, .indigo, .mint, .cyan, .gray]
    
    var body: some View {
        VStack {
            HeaderView()
            
            WheelOfFortuneView(
                shouldRemovePickedName: $shouldRemovePickedName,
                baseColorArray: $baseColorArray)
            
            NavigationLink("Список участников") {
                UserListView(shouldRemovePickedName: $shouldRemovePickedName,
                             baseColorArray: $baseColorArray)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        
    }
}



#Preview {
    ContentView()
        .modelContainer(for: PersonData.self)
}
