//
//  View+ReadSize.swift
//  UISample
//
//  Created by 정영민 on 2024/08/07.
//

import SwiftUI

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}


struct ElementPreferenceData: Equatable {
    let id: AnyHashable
    let size: CGSize
}

struct ElementPreferenceKey: PreferenceKey {
    typealias Value = [ElementPreferenceData]

    static var defaultValue: [ElementPreferenceData] = []

    static func reduce(value: inout [ElementPreferenceData], nextValue: () -> [ElementPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct PreferenceSetter<ID: Hashable>: View {
    var id: ID
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: ElementPreferenceKey.self, value: [ElementPreferenceData(id: AnyHashable(self.id), size: geometry.size)])
        }
    }
}
