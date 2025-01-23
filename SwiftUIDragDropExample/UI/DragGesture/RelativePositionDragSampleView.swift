//
//  RelativePositionDragSampleView.swift
//  SwiftUIDragDropExample
//
//  Created by tiandt on 2025/1/23.
//

import SwiftUI

struct RelativePositionDragSampleView: View {
    static let coordinateSpace = "coordinateSpace"

    @State private var offset: CGPoint = .init(x: 0, y: -100)
    @GestureState private var updatingOffset: CGPoint = .zero
    var body: some View {
        ZStack {
            let gesture = DragGesture(coordinateSpace: .named(Self.coordinateSpace))
                .updating($updatingOffset) { value, state, transaction in
                    if state == .zero {
                        state = offset
                    }
                    offset = .init(x: state.x + value.translation.width, y: state.y + value.translation.height)
                }

            Text("offset x:\(offset.x.formatted()), y:\(offset.y.formatted())")

            Text("Drag me")
                .padding()
                .contentShape(.rect)
                .offset(x: offset.x, y: offset.y)
                .gesture(gesture) // !!!: requires below `offset` modifier if no coordinateSpace
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .coordinateSpace(name: Self.coordinateSpace)
    }
}
