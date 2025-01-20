//
//  PlainDropDelegate.swift
//  SwiftUIDragDropExample
//
//  Created by tiandt on 2025/1/20.
//

import SwiftUI

struct PlainDropDelegate<Item>: DropDelegate where Item: Equatable {
    let item: Item
    @Binding var data: [Item]
    @Binding var draggedItem: Item?
    @Binding var isDropTarget: Bool

    init(
        item: Item,
        data: Binding<[Item]>,
        draggedItem: Binding<Item?>,
        isDropTarget: Binding<Bool> = .constant(false)
    ) {
        self.item = item
        self._data = data
        self._draggedItem = draggedItem
        self._isDropTarget = isDropTarget
    }

    func dropExited(info: DropInfo) {
        isDropTarget = false
    }

    func dropEntered(info: DropInfo) {
        isDropTarget = true
        guard item != draggedItem,  let current = draggedItem, let from = data.firstIndex(of: current), let to = data.firstIndex(of: item) else { return }

        if data[to] != current {
            withAnimation {
                data.move(fromOffsets: IndexSet(integer: from), toOffset: (to > from) ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        if data.contains(item) {
            DropProposal(operation: .move)
        } else {
            DropProposal(operation: .copy)
        }
    }

    func performDrop(info: DropInfo) -> Bool {
        isDropTarget = false
        draggedItem = nil
        return true
    }
}
