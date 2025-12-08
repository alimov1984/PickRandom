//
//  EditUserView.swift
//  PickRandom
//
//  Created by Андрей on 02.11.2025.
//
import SwiftUI

struct EditUserView: View {
    @Bindable var person: PersonData
    @Binding var isEditing: Bool
    @Environment(\.modelContext) private var context
    let characterLimit: Int = 2
    
    var body: some View {
        TextField("Add name", text: $person.name)
            .onChange(of: person.name) { oldValue, newValue in
                print("Too long oldValue: \(oldValue), newValue: \(newValue)")
                if newValue.count > characterLimit {
                    person.name = String(newValue.prefix(characterLimit))
                }
            }
        HStack(alignment: .bottom)
        {
            Toggle(person.name, isOn: $person.activated)
                .labelsHidden()
            if isEditing {
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        context.delete(person)
                    }
                } label: {
                    Image(systemName: "xmark.square.fill")
                        .font(.title2)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, Color.accentColor)
                }
                .offset(x: 7, y: -7)
            }
        }
    }
    
}
