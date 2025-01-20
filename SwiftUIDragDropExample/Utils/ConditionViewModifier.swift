//
//  ConditionViewModifier.swift
//  
//
//  Created by tdt on 2021/3/8.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func runtimeModifier<Content: View>(@ViewBuilder transform: (Self) -> Content) -> some View {
         transform(self)
    }
}
