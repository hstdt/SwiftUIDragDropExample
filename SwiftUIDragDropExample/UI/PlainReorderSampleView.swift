//
//  PlainReorderSampleView.swift
//  SwiftUIDragDropExample
//
//  Created by tiandt on 2025/1/20.
//

import SwiftUI

struct PlainReorderSampleView: View {
    @State private var columnCount = 3
#if !os(macOS)
    @State private var showDragPreview: Bool = true
#endif
    @State private var data: [OceanRegion] = oceanRegions
    @State private var draggingItem: OceanRegion?
    @State private var dropType: DropImplementionType = .dropDelegate

    enum DropImplementionType: CaseIterable, Sendable, Hashable {
        case dropDelegate
        case dropdDestination

        var name: String {
            switch self {
            case .dropdDestination:
                "Drop Destination"
            case .dropDelegate:
                "Drop Delegate"
            }
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Stepper(value: $columnCount, in: 1...5, step: 1) { Text("columnCount:\(columnCount.formatted())") }
#if !os(macOS)
                Toggle(isOn: $showDragPreview) {  Text("showDragPreview") }
                    .padding(.horizontal)
#endif
                Picker(dropType.name, selection: $dropType) {
                    ForEach(DropImplementionType.allCases, id: \.self) {
                        Text($0.name).tag($0)
                    }
                }
            }
            .padding()
            content
        }
        .background(Color.orange.mix(with: .cyan, by: 0.3).gradient)
        .animation(.default, value: columnCount)
        .navigationTitle("Plain")
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }

    @ViewBuilder
    private var content: some View {
        let columns = Array(repeating: GridItem(spacing: 10), count: columnCount)
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(data, id: \.self) { item in
                row(of: item)
                    .runtimeModifier {
#if os(macOS)
                        $0.onDrag {
                            draggingItem = item
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
                                }
                            }
                        } else {
                            $0.onDrag {
                                draggingItem = item
                                return NSItemProvider(object: "\(item.hashValue)" as NSString)
                            }
                        }
#endif
                    }
                    .runtimeModifier {
                        switch dropType {
                        case .dropDelegate:
                            $0.onDrop(
                                of: [.data],
                                delegate: PlainDropDelegate(
                                    item: item,
                                    data: $data,
                                    draggedItem: $draggingItem
                                )
                            )
                        case .dropdDestination:
                            $0.dropDestination(for: OceanRegion.self) { items, location in
                                draggingItem = nil
                                return false
                            } isTargeted: { status in
                                if let draggingItem, status, draggingItem != item {
                                    if let from = data.firstIndex(of: draggingItem), let to = data.firstIndex(of: item) {
                                        withAnimation {
                                            data.move(fromOffsets: IndexSet(integer: from), toOffset: (to > from) ? to + 1 : to)
                                        }
                                    }
                                }
                            }
                        }
                    }
                .frame(height: 44)
            }
        }
    }

    @ViewBuilder
    func row(of item: OceanRegion) -> some View {
        Text(item.name)
            .frame(height: 44)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .contentShape(.rect)
    }
}

#Preview {
    PlainReorderSampleView()
}

struct ContentView1: View {
    @State private var showDialog = false
    let options = Array(1...40).map { "Option \($0)" }

    var body: some View {
        VStack {
            Button("Show Options") {
                showDialog = true
            }
            .confirmationDialog("Choose an Option", isPresented: $showDialog) {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        print("\(option) selected")
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

#Preview {
    ContentView1()
}
