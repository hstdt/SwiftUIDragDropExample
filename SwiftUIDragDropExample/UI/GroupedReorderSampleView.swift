//
//  GroupedReorderSampleView.swift
//  SwiftUIDragDropExample
//
//  Created by tiandt on 2025/1/20.
//

import SwiftUI
import Collections

struct GroupedReorderSampleView: View {
#if !os(macOS)
    @State private var showDragPreview: Bool = true
#endif
    @State private var data: OrderedDictionary<OceanRegion, [Sea]> = OrderedDictionary(
        uniqueKeysWithValues: oceanRegions.map { ($0, $0.seas) })
    @State private var draggingItem: Sea?
    @State private var draggingGroup: OceanRegion?

    var body: some View {
        VStack(spacing: 0) {
#if !os(macOS)
            Toggle(isOn: $showDragPreview) {  Text("showDragPreview") }
                .padding(.horizontal)
#endif
            ScrollView(.vertical, showsIndicators: false) {
                content
            }
        }
        .background(Color.orange.mix(with: .cyan, by: 0.3).gradient)
        .navigationTitle("Grouped")
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }

    @ViewBuilder
    private var content: some View {
        LazyVStack(alignment: .center, spacing: 0) {
            ForEach(Array(data.keys), id: \.self) { group in
                section(of: group)
                    .runtimeModifier {
#if os(macOS)
                        $0.onDrag {
                            draggingItem = nil
                            draggingGroup = group
                            return NSItemProvider(object: "\(group.hashValue)" as NSString)
                        }
#else
                        if #available(iOS 16, *) {
                            $0.draggable(group) {
                                ZStack {
                                    if showDragPreview {
                                        section(of: group)
                                    } else {
                                        RoundedRectangle(cornerRadius: 4)
                                            .frame(width: 1, height: 1)
                                            .opacity(0.01)
                                    }
                                }
                                .onAppear {
                                    draggingItem = nil
                                    draggingGroup = group
                                }
                            }
                        } else {
                            $0.onDrag {
                                draggingItem = nil
                                draggingGroup = group
                                return NSItemProvider(object: "\(group.hashValue)" as NSString)
                            }
                        }
#endif
                    }
            }
        }
    }

    @ViewBuilder
    func section(of group: OceanRegion) -> some View {
        let items = data[group] ?? []
        GroupBox {
            ForEach(Array(items.enumerated()), id: \.element) { index, item in
                row(of: item)
                    .runtimeModifier {
#if os(macOS)
                        $0.onDrag {
                            draggingItem = item
                            draggingGroup = group
                            return NSItemProvider(object: "\(item.hashValue)" as NSString)
                        }
#else
                        if #available(iOS 16, *) {
                            $0.draggable(item) {
                                ZStack {
                                    if showDragPreview {
                                        row(of: item)
                                    } else {
                                        RoundedRectangle(cornerRadius: 4)
                                            .frame(width: 1, height: 1)
                                            .opacity(0.01)
                                    }
                                }
                                .onAppear {
                                    draggingItem = item
                                    draggingGroup = group
                                }
                            }
                        } else {
                            $0.onDrag {
                                draggingItem = item
                                draggingGroup = group
                                return NSItemProvider(object: "\(item.hashValue)" as NSString)
                            }
                        }
#endif
                    }
                    .onDrop(
                        of: [.data],
                        delegate: GroupedReorderItemDropDelegate(
                            group: group,
                            item: item,
                            data: $data,
                            draggedGroup: $draggingGroup,
                            draggedItem: $draggingItem
                        )
                    )
            }
        } label: {
            HStack {
                Text(group.name)
                Image(systemName: "line.3.horizontal")
                    .font(.system(.body))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            .frame(height: 44)
            .contentShape(.rect)
            .onDrop(
                of: [.data],
                delegate: GroupedReorderGroupDropDelegate(
                    group: group,
                    data: $data,
                    draggedGroup: $draggingGroup,
                    draggedItem: $draggingItem
                )
            )
        }
        .groupBoxStyle(PlainVerticalGroupBox())
    }

    @ViewBuilder
    func row(of item: Sea) -> some View {
        HStack(spacing: 0) {
            Text(item.name)

            Spacer()

            Image(systemName: "line.3.horizontal")
                .font(.system(.body))

        }
        .frame(height: 44)
        .padding(.horizontal)
        .contentShape(.rect)
    }
}

#Preview {
    GroupedReorderSampleView()
}
