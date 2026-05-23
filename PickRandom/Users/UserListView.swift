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
    private let maxTextLength: Int = 11
    
    @Query(sort: \PersonData.name)
    private var persons: [PersonData] = []
    
    @State
    private var nameToAdd = ""
    
    @Environment(\.modelContext)
    private var context
    
    private var gridColumns : [GridItem] = [GridItem(.fixed(300))]
    
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
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 20) {
                   // GridRow {
                    //    Text("Участники")
                   // }
                  //  .font(.headline)
                    VStack(spacing: 10) {
                        ForEach(persons) { person in
                            
                            EditUserView(person: person, isEditing: $isEditing)
                            if person != persons.last {
                                Divider()
                            }
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
            
            Divider()
            
            TextField("Имя нового участника", text: $nameToAdd)
                .autocorrectionDisabled()
                .onSubmit {
                    performSubmission()
                }.onChange(of: nameToAdd) { oldValue, newValue in
                    if newValue.count > maxTextLength {
                        nameToAdd = String(newValue.prefix(maxTextLength))
                    }
                }
            Button {
                performSubmission()
            }
            label: {
                Text("Добавить")
                    .padding(.vertical, 2)
                    .padding(.horizontal, 4)
            }
            .buttonStyle(.borderedProminent)
            .font(.system(size: 15))
            .padding()
            
            Divider()
            Button("Активировать всех") {
                persons.forEach({ $0.activated = true })
                baseColorArray = baseColorArray.shuffled()
            }
            .font(.title3)
            .padding()
            Toggle("Деактивировать после выбора", isOn: $shouldRemovePickedName)
                .padding()
        }
        .padding()
        .navigationTitle("Участники")
    }
    
    func performSubmission() {
        if !nameToAdd.isEmpty {
            let newPerson = PersonData(
                name: nameToAdd,
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
    NavigationStack{
        UserListView(shouldRemovePickedName: $shouldRemovePickedName,
                     baseColorArray: $baseColorArray)
        .modelContainer(SampleData.shared.modelContainer)
    }
}
