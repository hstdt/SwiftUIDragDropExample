//
//  ContentView.swift
//  SwiftUIDragDropExample
//
//  Created by tiandt on 2025/1/20.
//

import SwiftUI
import Collections

enum SampleType: String, CaseIterable, Identifiable {
    case plainReorder = "Plain Reorder"
    case groupdReorder = "Grouped Reorder"

    var id: String { rawValue }

    // 返回对应的视图
    @ViewBuilder
    func destinationView() -> some View {
        switch self {
        case .plainReorder:
            PlainReorderSampleView()
        case .groupdReorder:
            GroupedReorderSampleView()
        }
    }
}

struct ContentView: View {
    @State private var destination: SampleType?

    var body: some View {
        NavigationSplitView {
            List(SampleType.allCases, id: \.id, selection: $destination) { type in
                NavigationLink(value: type) {
                    Text(type.rawValue)
                }
                .tag(type.id)
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
