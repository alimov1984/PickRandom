//
//  EditUserView.swift
//  PickRandom
//
//  Created by Андрей on 02.11.2025.
//
import SwiftUI

struct EditUserView: View {
    @Bindable
    var person: PersonData
    
    @Binding
    var isEditing: Bool
    
    @Environment(\.modelContext)
    private var context
    
    private let maxTextLength: Int = 11
    
    var body: some View {
  
        HStack(alignment: .bottom)
        {
            TextField("Add name", text: $person.name)
                  .onChange(of: person.name) { oldValue, newValue in
                      if newValue.count > maxTextLength {
                          person.name = String(newValue.prefix(maxTextLength))
                      }
                  }
            Toggle(person.name, isOn: $person.activated)
                .labelsHidden().frame(minWidth: 30, maxWidth: 30)
            
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    context.delete(person)
                }
            }
            label: {
                Image(systemName: "xmark.square.fill")
                    .font(.title2)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, Color.accentColor)
            }
            .offset(x: 20, y: -4)
            .opacity(!isEditing ? 0 : 1)
            .disabled(!isEditing)
        }
    }
    
}
