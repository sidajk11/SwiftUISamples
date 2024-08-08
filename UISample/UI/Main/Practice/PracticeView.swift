//
//  PracticeView.swift
//  UISample
//
//  Created by 정영민 on 2024/08/05.
//

import SwiftUI
import WaterfallGrid

extension PracticeView {
    enum Route: Routable {
        case main
        case login
    }
    
    // Builds the views
    @ViewBuilder func routing(for route: Route) -> some View {
        switch route {
        case .login:
            LoginView(viewModel: .init(baseViewModel: viewModel))
        case .main:
            MainView(viewModel: .init(baseViewModel: viewModel))
        }
    }
}


struct PracticeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var geometrySize: CGSize = .zero
    @State private var preferences: [ElementPreferenceData] = []
    
    private let horizontalSpacing: CGFloat = 10
    private let horizontalPadding: CGFloat = 12
    
    @State private var gridHeight: CGFloat = 0

    @State private var alignmentGuides = [AnyHashable: CGPoint]()
    
    var body: some View {
        
        content
            .navigationTitle("Practice")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left") // Custom back button icon
                            Text("Back") // Custom back button text
                        }
                    }
                }
            }
            .readSize(onChange: { size in
                geometrySize = size
                layout()
            })
            .onAppear() {
                
            }
    }
    
    var content: some View {
        ScrollView {
            VStack {
                GeometryReader { geometry in
                    self.grid()
                        .onPreferenceChange(ElementPreferenceKey.self, perform: { preferences in
                            self.preferences = preferences
                            layout()
                        })
                }
            }
            .frame(width: nil, height: nil)
        }
    }
    
    private func grid() -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(viewModel.list, id: \.id) { cellVM in
                TextCell(viewModel: cellVM)
                    .background(PreferenceSetter(id: cellVM.id))
                    .alignmentGuide(.top, computeValue: { _ in self.alignmentGuides[cellVM.id]?.y ?? 0 })
                    .alignmentGuide(.leading, computeValue: { _ in self.alignmentGuides[cellVM.id]?.x ?? 0 })
                    //.opacity(self.alignmentGuides[cellVM.id] != nil ? 1 : 0)
            }
        }
    }
}

extension PracticeView {
    func layout() {
        guard preferences.count > 0 else { return }
        guard geometrySize.width > .ulpOfOne else { return }
        
        var alignmentGuides = [AnyHashable: CGPoint]()
        
        var width: CGFloat = 0
        var totalHeight: CGFloat = 0

        preferences.forEach { preference in
            let preferenceSizeWidth = preference.size.width
            let preferenceSizeHeight = preference.size.height
            if width > geometrySize.width {
                width = 0
                totalHeight += preferenceSizeHeight
            }
            let height = totalHeight
            let offset = CGPoint(x: 0 - (width),
                                 y: 0 - (height))
            alignmentGuides[preference.id] = offset
            
            width = width + preferenceSizeWidth + 10
        }
        
        self.alignmentGuides = alignmentGuides
    }
    
    func alignmentsAndGridHeight(geometry: GeometryProxy, preferences: [ElementPreferenceData]) -> ([AnyHashable: CGPoint], CGFloat) {
        
        var alignmentGuides = [AnyHashable: CGPoint]()
        
        var totalWidth: CGFloat = 0
        var totalHeight: CGFloat = 0

        preferences.forEach { preference in
            let preferenceSizeWidth = preference.size.width
            let preferenceSizeHeight = preference.size.height
            var width = totalWidth + preferenceSizeWidth + 10
            if width > geometrySize.width {
                width = 0
                totalWidth = 0
                totalHeight += preferenceSizeHeight
            }
            let height = totalHeight
            let offset = CGPoint(x: 0 - (width),
                                 y: 0 - (height))
            alignmentGuides[preference.id] = offset
        }
        
        //let gridHeight = max(0, (heights.max() ?? 10) - 10)
        
        return (alignmentGuides, 1000)
//        var alignmentGuides = [AnyHashable: CGPoint]()
//
//        preferences.forEach { preference in
//            let width = preference.size.width
//            let height = preference.size.height
//            let offset = CGPoint(x: 0 - width,
//                                 y: 0 - height)
//            alignmentGuides[preference.id] = offset
//        }
//        
//        let gridHeight: CGFloat = 1000
//        
//        return (alignmentGuides, gridHeight)
    }
    
    private func arrangeItem(containerWidth: CGFloat, preferences: [ElementPreferenceData]) -> [[TextCell.ViewModel]] {
        let contentWidth = containerWidth - horizontalPadding * 2
        var width: CGFloat = 0
        
        var arrangeItems: [[TextCell.ViewModel]] = []
        var rows: [TextCell.ViewModel] = []
        
        for element in preferences {
            guard let cellVM = viewModel.cellVMList[element.id] else { continue }
            
            let cellWidth = element.size.width
            width += cellWidth
            if width > contentWidth {
                arrangeItems.append(rows)
                rows = []
                width = cellWidth
            }
            rows.append(cellVM)
            width += horizontalSpacing
        }
        if rows.count > 0 {
            arrangeItems.append(rows)
        }
        
        return arrangeItems
    }
    
    private func arrangeItems(_ cellVMList: [TextCell.ViewModel], containerWidth: CGFloat, horizontalSpacing: CGFloat, horizontalPadding: CGFloat) -> [[TextCell.ViewModel]] {
        
        let contentWidth = containerWidth - horizontalPadding * 2
        var width: CGFloat = 0
        
        var arrangeItems: [[TextCell.ViewModel]] = []
        var rows: [TextCell.ViewModel] = []
        
        for cellVM in cellVMList {
            let cellWidth = cellVM.text.width(withConstrainedHeight: .greatestFiniteMagnitude, font: .body1)
            print("\(cellVM.text) calc size: \(cellWidth)")
            width += cellWidth
            if width > contentWidth {
                arrangeItems.append(rows)
                rows = []
                width = cellWidth
            }
            rows.append(cellVM)
            width += horizontalSpacing
        }
        if rows.count > 0 {
            arrangeItems.append(rows)
        }
        
        return arrangeItems
    }
}

extension PracticeView {
    class ViewModel: BaseViewModel {
        
        var lessonModel: LessonModel!
        
        @Published var title: String = ""
        
        @Published var list: [TextCell.ViewModel] = []
        
        @Published var cellVMList: [AnyHashable : TextCell.ViewModel] = [:]
        
        @Published var itemsArranged: [[TextCell.ViewModel]] = []
        
        func fetch() {
            let text = "SwiftUI is a modern framework ______ introduced by Apple for building user interfaces"
            let components = text.components(separatedBy: .whitespaces)
            
            var dict: [AnyHashable : TextCell.ViewModel] = [:]
            var list: [TextCell.ViewModel] = []
            let count = components.count
            for i in 0 ..< count {
                let component = components[i]
                let cellVM = TextCell.ViewModel(container: container)
                cellVM.text = component
                cellVM.index = i
                dict[cellVM.id] = cellVM
                list.append(cellVM)
            }
            cellVMList = dict
            
            itemsArranged = [list]
            
            self.list = list
        }
        
        static func viewModel(container: DIContainer, lessonModel: LessonModel) -> ViewModel {
            let vm = ViewModel(container: container)
            vm.lessonModel = lessonModel
            
            vm.title = lessonModel.title
            
            vm.fetch()
            
            return vm
        }
    }
}

#Preview {
    PracticeView(viewModel: .init(container: .preview))
}
