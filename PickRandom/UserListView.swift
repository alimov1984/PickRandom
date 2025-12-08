//
//  UserListView.swift
//  PickRandom
//
//  Created by Андрей on 06.12.2025.
//
import SwiftUI
import SwiftData
import OSLog

public struct UserListView: View {
    @Query(sort: \PersonData.name)
    private var persons: [PersonData] = []
    
    @State
    private var nameToAdd = ""
    
    @Environment(\.modelContext)
    private var context
    
    private var gridColumns = Array(repeating: GridItem(.flexible()), count: 2)
    
    @State
    private var isEditing = false
    
    @Binding
    var shouldRemovePickedName : Bool
    
    @Binding
    var baseColorArray: [Color]
    
    init(shouldRemovePickedName: Binding<Bool>, baseColorArray: Binding<[Color]>)
    {
        self._shouldRemovePickedName = shouldRemovePickedName
        self._baseColorArray = baseColorArray
    }
    
    public var body: some View {
        VStack {
            HeaderView()
            
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 20) {
                    GridRow {
                        Text("Имя участника")
                        Text("")
                    }
                    .font(.headline)
                    ForEach(persons) { person in
                        EditUserView(person: person, isEditing: $isEditing)
                        if person != persons.last {
                            //Divider()
                        }
                    }
                }
                .padding(.vertical)
                .offset(x:0, y:0)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(isEditing ? "Сохранить" : "Удалить") {
                            withAnimation { isEditing.toggle() }
                        }
                    }
                }
            }
            
            HStack
            {
                TextField("Имя участника", text: $nameToAdd)
                    .autocorrectionDisabled()
                    .onSubmit {
                        performSubmission()
                    }
                Button("Добавить") {
                    performSubmission()
                }
                .buttonStyle(.borderedProminent)
                .font(.title3)
                .padding()
                
            }
            
            Divider()
            
            Toggle("Деактивировать после выбора", isOn: $shouldRemovePickedName)
                .padding()
            
            Button("Активировать всех") {
                persons.forEach({ $0.activated = true })
                baseColorArray = baseColorArray.shuffled()
            }
            .font(.title3)
            .padding()
        }
        .padding()
    }
    
    func performSubmission() {
        if !nameToAdd.isEmpty {
            let newPerson = PersonData(name: nameToAdd,
                                       activated: true
            )
            context.insert(newPerson)
            nameToAdd = ""
        }
    }
}

#Preview {
    @Previewable @State var shouldRemovePickedName = true
    @Previewable @State var baseColorArray: [Color] = [.blue, .red, .green]
    UserListView(shouldRemovePickedName: $shouldRemovePickedName,
                 baseColorArray: $baseColorArray)
        .modelContainer(for: PersonData.self)
}
