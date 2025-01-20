//
//  OceanRegion.swift
//  SwiftUIDragDropExample
//
//  Created by tiandt on 2025/1/20.
//

import Foundation
import CoreTransferable

public struct OceanRegion: Identifiable, Sendable, Hashable, Codable {
    public let name: String
    public let seas: [Sea]
    public var id = UUID()
}

public struct Sea: Hashable, Identifiable, Sendable, Codable {
    public let name: String
    public var id = UUID()
}

let oceanRegions: [OceanRegion] = [
    OceanRegion(name: "Pacific",
                seas: [Sea(name: "Australasian Mediterranean"),
                       Sea(name: "Philippine"),
                       Sea(name: "Coral"),
                       Sea(name: "South China")]),
    OceanRegion(name: "Atlantic",
                seas: [Sea(name: "American Mediterranean"),
                       Sea(name: "Sargasso"),
                       Sea(name: "Caribbean")]),
    OceanRegion(name: "Indian",
                seas: [Sea(name: "Bay of Bengal")]),
    OceanRegion(name: "Southern",
                seas: [Sea(name: "Weddell")]),
    OceanRegion(name: "Arctic",
                seas: [Sea(name: "Greenland")])
]

@available(iOS 16, *)
extension OceanRegion: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: OceanRegion.self, contentType: .data)
    }
}

@available(iOS 16, *)
extension Sea: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Sea.self, contentType: .data)
    }
}
