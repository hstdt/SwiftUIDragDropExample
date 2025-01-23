//
//  AbsolutePositionDragSampleView.swift
//  SwiftUIDragDropExample
//
//  Created by tiandt on 2025/1/23.
//

import SwiftUI

struct AbsolutePositionDragSampleView: View {
    static let coordinateSpace = "coordinateSpace"

    @State private var position: CGPoint = .init(x: 200, y: 200)
    @GestureState private var updatingPosition: CGPoint = .zero
    var body: some View {
        ZStack {
            let gesture = DragGesture(coordinateSpace: .named(Self.coordinateSpace))
                .updating($updatingPosition) { value, state, transaction in
                    if state == .zero {
                        state = position
                    }
                    position = .init(x: state.x + value.translation.width, y:  state.y + value.translation.height)
                }
            
            Text("position x:\(position.x.formatted()), y:\(position.y.formatted())")
            
            Text("Drag me")
                .padding()
                .contentShape(.rect)
                .position(x: position.x, y: position.y)
                .gesture(gesture) // !!!: requires below `position` modifier if no coordinateSpace
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .coordinateSpace(name: Self.coordinateSpace)
    }
}
