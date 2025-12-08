//
//  WheelOfFortuneView.swift
//  PickRandom
//
//  Created by Андрей on 22.11.2025.
//
import SwiftUI
import SwiftData
import OSLog

public struct WheelOfFortuneView: View {
    
    @Query(
        filter: #Predicate<PersonData> { person in person.activated})
    private var persons: [PersonData] = []
    
    @Binding
    var shouldRemovePickedName : Bool
    
    @Binding
    var baseColorArray: [Color]
    
    @State
    private var currentRotation: Double = 0
    
    @State
    private var winnerName: String = "";
    
    @State
    private var winnerPerson: PersonData?
    
    @State
    private var isSpinning: Bool = false
    
    @State
    private var isLargeWinner: Bool = false
    
    init(shouldRemovePickedName: Binding<Bool>, baseColorArray: Binding<[Color]>)
    {
        self._shouldRemovePickedName = shouldRemovePickedName
        self._baseColorArray = baseColorArray
    }
    
    public var body: some View {
        VStack
        {
            Text(winnerName.isEmpty ? " " : winnerName)
                .font(isLargeWinner ? .largeTitle : .body)
                .bold()
                .foregroundStyle(.tint)
                .animation(.easeOut(duration: 0.5), value: isLargeWinner)
                .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Image("Arrow")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

            ZStack
            {
                ForEach(Array(persons.enumerated()), id: \.offset) { index, person in
                    WheelSegment(index: index,
                                 totalSegments: persons.count,
                                 color: getRandomColor(index: index),
                                 personName: person.name)
                }
            }
            .frame(width: 300, height: 300)
            .rotationEffect(Angle.degrees(currentRotation))
            .onTapGesture {
                if !isExistActivatedPerson() || isSpinning { return }
                startSpinning()
            }
            .animation(.easeOut(duration:5.0), value: currentRotation)
            
            Button {
                startSpinning()
            } label: {
                Text("Крутить")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 26)
            }
            .padding()
            .buttonStyle(.borderedProminent)
            .font(.title2)
            .disabled(!isExistActivatedPerson() || isSpinning)
        }
    }
    
    func isExistActivatedPerson() -> Bool {
        return persons.filter({$0.activated}).count > 0
    }
    
    func startSpinning()
    {
        if shouldRemovePickedName && winnerPerson != nil {
            winnerPerson!.activated = false
        }
        winnerName = ""
        winnerPerson = nil
        isLargeWinner = false
        if (!isExistActivatedPerson())
        {
            return
        }
        isSpinning = true
        let randomSpinAmount = Double.random(in: 0...360) + 2880
        currentRotation += randomSpinAmount
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            winnerPerson = getWinnerPerson(currentRotation: currentRotation)
            winnerName = winnerPerson?.name ?? ""
            withAnimation {
                isLargeWinner.toggle()
            }
            print("Winner name: \(winnerPerson?.name ?? "No winner") | current rotation: \(currentRotation)")
            isSpinning = false
        }
    }
    
    func getWinnerPerson(currentRotation: Double) -> PersonData?
    {
        var winnerPerson: PersonData? = nil
        let resultAngle: Angle = getAngle(angle: currentRotation)
        print("resultAngle: \(resultAngle.degrees)")
        let anglePerSegment: Angle = .degrees(360 / Double(persons.count))
        
        for (index, person) in persons.enumerated() {
            let startAngle: Angle = anglePerSegment * Double(index)
            let endAngle: Angle = anglePerSegment * Double(index + 1)
            if (resultAngle.degrees >= startAngle.degrees && resultAngle.degrees < endAngle.degrees) {
                winnerPerson = person
                print("startAngle: \(startAngle.degrees), endAngle: \(endAngle.degrees), resultAngle: \(resultAngle.degrees)")
                break;
            }
        }
        return winnerPerson
    }
    
    func getRandomColor(index:Int) -> Color {
        var newIndex = index;
        if (newIndex >= baseColorArray.count) {
            newIndex = newIndex % baseColorArray.count
        }
        return baseColorArray[newIndex]
    }

    
    func getAngle(angle: Double) -> Angle {
        let deg:Double = 360 - angle.truncatingRemainder(dividingBy: 360) - 90
        if deg < 0 {
            return Angle(degrees: 360 - abs(deg))
        } else
        {
            return Angle(degrees: deg)
        }
    }
}

#Preview {
    @Previewable @State var shouldRemovePickedName = true
    @Previewable @State var baseColorArray: [Color] = [.blue, .red, .green]
    WheelOfFortuneView(shouldRemovePickedName: $shouldRemovePickedName,
                 baseColorArray: $baseColorArray)
        .modelContainer(for: PersonData.self)
}
