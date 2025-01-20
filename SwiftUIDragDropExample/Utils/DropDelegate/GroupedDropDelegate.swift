//
//  GroupedReorderItemDropDelegate.swift
//  SwiftUIDragDropExample
//
//  Created by tiandt on 2025/1/20.
//

import SwiftUI
import OrderedCollections

struct GroupedReorderItemDropDelegate<Group, Item>: DropDelegate where Group: Hashable, Item: Equatable {
    let group: Group
    let item: Item
    @Binding var data: OrderedDictionary<Group, [Item]>
    @Binding var draggedGroup: Group?
    @Binding var draggedItem: Item?
    @Binding var isDropTarget: Bool

    init(
        group: Group,
        item: Item,
        data: Binding<OrderedDictionary<Group, [Item]>>,
        draggedGroup: Binding<Group?>,
        draggedItem: Binding<Item?>,
        isDropTarget: Binding<Bool> = .constant(false)
    ) {
        self.group = group
        self.item = item
        self._data = data
        self._draggedGroup = draggedGroup
        self._draggedItem = draggedItem
        self._isDropTarget = isDropTarget
    }

    func dropExited(info: DropInfo) {
        isDropTarget = false
    }

    func dropEntered(info: DropInfo) {
        isDropTarget = true
        guard var items = data[group] else { return }
        if let draggedItem {
            guard item != draggedItem, let to = items.firstIndex(of: item) else { return }
            if let from = items.firstIndex(of: draggedItem) {
                // inside secion
                if items[to] != draggedItem {
                    withAnimation {
                        items.move(fromOffsets: IndexSet(integer: from), toOffset: (to > from) ? to + 1 : to)
                        data[group] = items
                    }
                }
            } else if let draggedGroup, var draggedItems = data[draggedGroup], let from = draggedItems.firstIndex(of: draggedItem) {
                // between secion
                withAnimation {
                    draggedItems.remove(at: from)
                    data[draggedGroup] = draggedItems
                    items.insert(draggedItem, at: to)
                    data[group] = items
                    self.draggedGroup = group
                }
            }
        }
        /*
        else if let draggedGroup {
            var groups = Array(data.keys)
            guard group != draggedGroup, let to = groups.firstIndex(of: group) else { return }
            if let from = groups.firstIndex(of: draggedGroup) {
                print("from:\(from)")
                print("to:\(to)")
                if groups[to] != draggedGroup {
                    withAnimation(.none) {
                        groups.move(fromOffsets: IndexSet(integer: from), toOffset: (to > from) ? to + 1 : to)
                        data.sort { lhs, rhs in
                            guard let lhsIndex = groups.firstIndex(of: lhs.key),
                                  let rhsIndex = groups.firstIndex(of: rhs.key) else {
                                return false
                            }
                            return lhsIndex < rhsIndex
                        }
                    }
                }
            }
        }
         */
    }

    func performDrop(info: DropInfo) -> Bool {
        isDropTarget = false
        draggedItem = nil
        draggedGroup = nil
        return true
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        guard draggedItem != nil else { return DropProposal(operation: .forbidden) }
        guard let items = data[group] else { return DropProposal(operation: .forbidden) }
        return if items.contains(item) {
            DropProposal(operation: .move)
        } else {
            DropProposal(operation: .copy)
        }
    }
}

struct GroupedReorderGroupDropDelegate<Group, Item>: DropDelegate where Group: Hashable, Item: Equatable {
    let group: Group
    @Binding var data: OrderedDictionary<Group, [Item]>
    @Binding var draggedGroup: Group?
    @Binding var draggedItem: Item?
    @Binding var isDropTarget: Bool

    init(
        group: Group,
        data: Binding<OrderedDictionary<Group, [Item]>>,
        draggedGroup: Binding<Group?>,
        draggedItem: Binding<Item?>,
        isDropTarget: Binding<Bool> = .constant(false)
    ) {
        self.group = group
        self._data = data
        self._draggedGroup = draggedGroup
        self._draggedItem = draggedItem
        self._isDropTarget = isDropTarget
    }

    func dropExited(info: DropInfo) {
        isDropTarget = true
    }

    func dropEntered(info: DropInfo) {
        isDropTarget = true
        guard var items = data[group] else { return }
        if let draggedItem {
            if draggedGroup == group { return } // ignore movement inside section
            if let draggedGroup, var draggedItems = data[draggedGroup], let from = draggedItems.firstIndex(of: draggedItem) {
                withAnimation {
                    draggedItems.remove(at: from)
                    data[draggedGroup] = draggedItems
                    items.insert(draggedItem, at: 0)
                    data[group] = items
                    self.draggedGroup = group
                }
            }
        } else if let draggedGroup {
            var groups = Array(data.keys)
            guard group != draggedGroup, let to = groups.firstIndex(of: group) else { return }
            if let from = groups.firstIndex(of: draggedGroup) {
                if groups[to] != draggedGroup {
                    withAnimation {
                        groups.move(fromOffsets: IndexSet(integer: from), toOffset: (to > from) ? to + 1 : to)
                        data.sort { lhs, rhs in
                            guard let lhsIndex = groups.firstIndex(of: lhs.key),
                                  let rhsIndex = groups.firstIndex(of: rhs.key) else {
                                return false
                            }
                            return lhsIndex < rhsIndex
                        }
                    }
                }
            }
        }
    }

    func performDrop(info: DropInfo) -> Bool {
        isDropTarget = false
        draggedItem = nil
        draggedGroup = nil
        return true
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        guard draggedGroup != nil else { return DropProposal(operation: .forbidden) }
        return DropProposal(operation: .move)
    }
}
