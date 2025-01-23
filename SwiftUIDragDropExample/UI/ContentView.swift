//
//  ContentView.swift
//  SwiftUIDragDropExample
//
//  Created by tiandt on 2025/1/20.
//

import SwiftUI
import Collections

enum SampleSection: String, CaseIterable, Hashable {
    case dragdrop = "Drag Drop"
    case dragGesture = "DragGesture"
    var samples: [Sample] {
        switch self {
        case .dragdrop:
            [.plainReorder, .groupdReorder]
        case .dragGesture:
            [.absolutedragGesture, .relativedragGesture]
        }
    }
}

enum Sample: String, Identifiable, Hashable {
    case plainReorder = "Plain Reorder"
    case groupdReorder = "Grouped Reorder"
    case absolutedragGesture = "Absolute Drag Gesture"
    case relativedragGesture = "Relative Drag Gesture"

    var id: String { rawValue }

    // 返回对应的视图
    @ViewBuilder
    func destinationView() -> some View {
        switch self {
        case .plainReorder:
            PlainReorderSampleView()
        case .groupdReorder:
            GroupedReorderSampleView()
        case .absolutedragGesture:
            AbsolutePositionDragSampleView()
        case .relativedragGesture:
            RelativePositionDragSampleView()
        }
    }
}

struct ContentView: View {
    @State private var destination: Sample?

    var body: some View {
        NavigationSplitView {
            List(selection: $destination) {
                ForEach(SampleSection.allCases, id: \.self) { section in
                    Section {
                        ForEach(section.samples, id: \.self) { sample in
                            NavigationLink(value: sample) {
                                Text(sample.rawValue)
                            }
                        }
                    } header: {
                        Text(section.rawValue)
                    }
                }
            }
            .navigationTitle("Samples")
        } detail: {
            if let destination {
                destination.destinationView()
            } else {
                ContentUnavailableView("No Selection", systemImage: "doc.richtext.fill")
            }
        }
    }
}

#Preview {
    ContentView()
}
