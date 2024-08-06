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
    
    @State private var itemsArranged: [[TextCell.ViewModel]] = []
    
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
            .onAppear() {
                
            }
    }
    
    var content: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(0 ..< itemsArranged.count, id: \.self) { row in
                        let itemsInRow = itemsArranged[row]
                        HStack(spacing: 10) {
                            ForEach(0 ..< itemsInRow.count, id: \.self) { column in
                                let cellVM = itemsInRow[column]
                                TextCell(viewModel: cellVM)
                            }
                            Spacer()
                        }
                        
                        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                    }
                    GeometryReader { proxy in
                        HStack {} // just an empty container to triggers the onAppear
                            .onAppear {
                                itemsArranged = arrangeItems(viewModel.cellVMList, containerWidth: geometry.size.width, horizontalSpacing: 10, horizontalPadding: 12)
                            }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: geometry.size) { newValue in
                //itemsArranged = arrangeItems(viewModel.cellVMList, containerWidth: geometry.size.width, horizontalSpacing: 10, horizontalPadding: 12)
            }
        }
    }
}

extension PracticeView {
    private func arrangeItems(_ cellVMList: [TextCell.ViewModel], containerWidth: CGFloat, horizontalSpacing: CGFloat, horizontalPadding: CGFloat) -> [[TextCell.ViewModel]] {
        
        let contentWidth = containerWidth - horizontalPadding * 2
        var width: CGFloat = 0
        
        var arrangeItems: [[TextCell.ViewModel]] = []
        var rows: [TextCell.ViewModel] = []
        
        for cellVM in cellVMList {
            let cellWidth = cellVM.text.width(withConstrainedHeight: .infinity, font: .body1)
            width += cellWidth
            if width > contentWidth {
                arrangeItems.append(rows)
                rows = []
                width = 0
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
        
        @Published var cellVMList: [TextCell.ViewModel] = []
        
        func fetch() {
            let text = "This is a test content This is a test content This is a test content This is a test content"
            let components = text.components(separatedBy: .whitespaces)
            
            var list: [TextCell.ViewModel] = []
            let count = components.count
            for i in 0 ..< count {
                let component = components[i]
                let cellVM = TextCell.ViewModel(container: container)
                cellVM.text = component
                cellVM.index = i
                list.append(cellVM)
            }
            cellVMList = list
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
