//
//  PlainVerticalGroupBox.swift
//  SwiftUIDragDropExample
//
//  Created by tiandt on 2025/1/20.
//

import SwiftUI

struct PlainVerticalGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            configuration.label
            configuration.content
        }
    }
}
