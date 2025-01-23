//
//  GestureModifierNotBottomBugView.swift
//  SwiftUIDragDropExample
//
//  Created by tiandt on 2025/1/23.
//

import SwiftUI

struct GestureModifierNotBottomBugView: View {
    @GestureState private var offset: CGPoint = .init(x: 0, y: -100)
    var body: some View {
        ZStack {
            let gesture = DragGesture()
                .updating($offset) { value, state, transaction in
                    state = .init(x: value.translation.width, y: value.translation.height)
                }

            Text("offset x:\(offset.x.formatted()), y:\(offset.y.formatted())")

            Text("Drag me")
                .padding()
                .contentShape(.rect)
                .gesture(gesture) // !!!: lead to bug if this line is not at the bottom and no name space specific to gesture
                .offset(x: offset.x, y: offset.y)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    GestureModifierNotBottomBugView()
}
