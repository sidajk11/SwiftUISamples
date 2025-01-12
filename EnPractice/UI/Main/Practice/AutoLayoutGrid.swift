//
//  AutoLayoutGrid.swift
//  EnPractice
//
//  Created by 정영민 on 2024/08/12.
//

import SwiftUI

struct AutoLayoutGrid<Data, ID, Content>: View where Data : RandomAccessCollection, Content : View, ID : Hashable {
    
    private let data: Data
    private let dataId: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> Content
    
    var animation: Animation? = nil
    
    var alignment: HorizontalAlignment = .center
    @State private var geometrySize: CGSize = .zero
    @State private var preferences: [PreferenceSizeData] = []
    
    private let horizontalSpacing: CGFloat = 10
    private let horizontalPadding: CGFloat = 12

    @State private var loaded = false
    @State private var gridHeight: CGFloat?
    @State private var gridWidth: CGFloat?

    @State private var alignmentGuides = [AnyHashable: CGPoint]() {
        didSet {
            loaded = !oldValue.isEmpty
        }
    }
    
    var body: some View {
        HStack() {
            self.grid()
                .onPreferenceChange(ElementPreferenceKey.self, perform: { preferences in
                    self.preferences = preferences
                    layout()
                })
            .frame(width: gridWidth, height: gridHeight)
            
            if alignment == .leading {
                Spacer()
            }
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .readSize(onChange: { size in
            geometrySize = size
            layout()
        })
    }
}

extension AutoLayoutGrid {
    private func grid() -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(data, id: self.dataId) { element in
                self.content(element)
                    .background(PreferenceSetter(id: element[keyPath: self.dataId]))
                    .alignmentGuide(.top) { d in
                        self.alignmentGuides[element[keyPath: self.dataId]]?.y ?? 0
                    }
                    .alignmentGuide(.leading) { d in
                        self.alignmentGuides[element[keyPath: self.dataId]]?.x ?? 0
                    }
                    .opacity(self.alignmentGuides[element[keyPath: self.dataId]] != nil ? 1 : 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
        //.animation(self.loaded ? animation : nil, value: UUID())
    }
    
    private func layout() {
        guard preferences.count > 0 else { return }
        guard geometrySize.width > .ulpOfOne else { return }
        
        var alignmentGuides = [AnyHashable: CGPoint]()
        
        var posX: CGFloat = 0
        var posY: CGFloat = 0
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        let containerWidth = geometrySize.width - horizontalPadding * 2
        preferences.forEach { preference in
            let preferenceSizeWidth = preference.size.width
            let preferenceSizeHeight = preference.size.height
            if posX + preferenceSizeWidth > containerWidth {
                posX = 0
                posY += preferenceSizeHeight
            }
            let offset = CGPoint(x: 0 - (posX), y: 0 - (posY))
            alignmentGuides[preference.id] = offset
            
            if width < posX + preferenceSizeWidth {
                width = posX + preferenceSizeWidth
            }
            
            posX = posX + preferenceSizeWidth + horizontalSpacing
            height = posY + preferenceSizeHeight
        }
        
        self.alignmentGuides = alignmentGuides
        self.gridHeight = height
        self.gridWidth = width
    }
}

extension AutoLayoutGrid where ID == Data.Element.ID, Data.Element : Identifiable {

    init(_ data: Data, alignment: HorizontalAlignment, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.dataId = \Data.Element.id
        self.content = content
        self.alignment = alignment
    }
}

