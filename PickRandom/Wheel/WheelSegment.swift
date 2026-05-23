//
//  WheelSegment.swift
//  PickRandom
//
//  Created by Андрей on 22.11.2025.
//
import SwiftUI
import Foundation

struct WheelSegment: View {
    let index: Int
    let totalSegments: Int
    let color: Color
    let personName: String
    
    var body: some View {
        let center = CGPoint(x: 150, y: 150)
        let radius: CGFloat = 150
        let anglePerSegment: Angle = .degrees(360 / Double(totalSegments))
        let startAngle: Angle = anglePerSegment * Double(index)
        let endAngle: Angle = anglePerSegment * Double(index + 1)
        let textAngleInRadians: Angle = startAngle + anglePerSegment / 2
        let textOffsetX: CGFloat = radius / 2 * cos(textAngleInRadians.radians)
        let textOffsetY: CGFloat = radius / 2 * sin(textAngleInRadians.radians)
        
        Path { path in
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            path.closeSubpath()
        }
        .fill(color)
        
        Text(personName)
            .font(.title2)
            .rotationEffect(startAngle + anglePerSegment / 2, anchor: .center)
            .offset(x: textOffsetX, y: textOffsetY)
    }
}
