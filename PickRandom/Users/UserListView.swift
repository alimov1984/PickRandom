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
    
    @Environment(DataContainer.self)
    private var dataContainer
    
    private var gridColumns : [GridItem] = [GridItem(.fixed(300))]
    
    @State
    private var isEditing = false
    
    @Binding
    var shouldRemovePickedName : Bool
    
    @Binding
    var baseColorArray: [Color]
    
    @Binding
    var selectedTab : TabEnum
    
    init(shouldRemovePickedName: Binding<Bool>,
         baseColorArray: Binding<[Color]>,
    selectedTab: Binding<TabEnum>)
    {
        self._shouldRemovePickedName = shouldRemovePickedName
        self._baseColorArray = baseColorArray
        self._selectedTab = selectedTab
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
                            
                            EditUserView(person: person,
                                         isEditing: $isEditing,
                                         selectedTab: $selectedTab)
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
                .frame(minHeight: 200)
                .overlay {
                    if persons.isEmpty {
                        ContentUnavailableView {
                            Label("Нет участников", systemImage: "exclamationmark.circle.fill")
                            .foregroundStyle(.white, Color.accentColor)
                        } description: {
                            Text("Для добавления участника введите его имя в поле внизу")
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
            .scrollDismissesKeyboard(.interactively)
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
            dataContainer.context.insert(newPerson)
            nameToAdd = ""
        }
    }
}

#Preview {
    @Previewable @State var shouldRemovePickedName = true
    @Previewable @State var baseColorArray: [Color] = [.blue, .red, .green]
    @Previewable @State var selectedTab:TabEnum = .users
    NavigationStack{
        UserListView(shouldRemovePickedName: $shouldRemovePickedName,
                     baseColorArray: $baseColorArray,
                     selectedTab: $selectedTab)
        .sampleDataContainer()
    }
}
