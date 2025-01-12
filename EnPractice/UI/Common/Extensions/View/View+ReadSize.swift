//
//  View+ReadSize.swift
//  EnPractice
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

extension View {
    func readFrameInGlobal(onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: GlobleFramePreferenceKey.self, value: geometryProxy.frame(in: .global))
            }
        )
        .onPreferenceChange(GlobleFramePreferenceKey.self, perform: onChange)
    }
    
    func readFrame(in coordinate: CoordinateSpace, onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: GlobleFramePreferenceKey.self, value: geometryProxy.frame(in: coordinate))
            }
        )
        .onPreferenceChange(GlobleFramePreferenceKey.self, perform: onChange)
    }
}


struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct GlobleFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

struct PreferenceSizeData: Equatable {
    let id: AnyHashable
    let size: CGSize
}

struct ElementPreferenceKey: PreferenceKey {
    static var defaultValue: [PreferenceSizeData] = []

    static func reduce(value: inout [PreferenceSizeData], nextValue: () -> [PreferenceSizeData]) {
        value.append(contentsOf: nextValue())
    }
}

struct PreferenceSetter<ID: Hashable>: View {
    var id: ID
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: ElementPreferenceKey.self, value: [PreferenceSizeData(id: AnyHashable(self.id), size: geometry.size)])
        }
    }
}
