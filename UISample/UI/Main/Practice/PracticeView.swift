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
    }
    
    var content: some View {
        VStack {
            AutoLayoutGrid(viewModel.textCellVMlist) { vm in
                TextCell(viewModel: vm)
            }
            .border(.appBlue600)
            
            AutoLayoutGrid(viewModel.answerCellVMList) { vm in
                AnswerTextCell(viewModel: vm)
            }
            .border(.appRedOrange300)
            
            Spacer()
        }
    }
    
    private func sentenceView() -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(viewModel.textCellVMlist, id: \.id) { cellVM in
                TextCell(viewModel: cellVM)
                    .background(PreferenceSetter(id: cellVM.id))
                    .alignmentGuide(.top) { d in
                        self.alignmentGuides[cellVM.id]?.y ?? 0
                    }
                    .alignmentGuide(.leading) { d in
                        self.alignmentGuides[cellVM.id]?.x ?? 0
                    }
                    //.opacity(self.alignmentGuides[cellVM.id] != nil ? 1 : 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
        .border(.green)
    }
    
    private func answersView() -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(viewModel.answerCellVMList, id: \.id) { cellVM in
                AnswerTextCell(viewModel: cellVM)
                    .background(PreferenceSetter(id: cellVM.id))
                    .alignmentGuide(.top) { d in
                        self.alignmentGuides[cellVM.id]?.y ?? 0
                    }
                    .alignmentGuide(.leading) { d in
                        self.alignmentGuides[cellVM.id]?.x ?? 0
                    }
                    //.opacity(self.alignmentGuides[cellVM.id] != nil ? 1 : 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
        .border(.green)
    }
}

extension PracticeView {
    func layout() {
        guard preferences.count > 0 else { return }
        guard geometrySize.width > .ulpOfOne else { return }
        
        var alignmentGuides = [AnyHashable: CGPoint]()
        
        var width: CGFloat = 0
        var totalHeight: CGFloat = 0
        
        let containerWidth = geometrySize.width - horizontalPadding * 2
        preferences.forEach { preference in
            let preferenceSizeWidth = preference.size.width
            let preferenceSizeHeight = preference.size.height
            if width + preferenceSizeWidth > containerWidth {
                width = 0
                totalHeight += preferenceSizeHeight
            }
            let offset = CGPoint(x: 0 - (width), y: 0 - (totalHeight))
            alignmentGuides[preference.id] = offset
            
            width = width + preferenceSizeWidth + horizontalSpacing
        }
        
        self.alignmentGuides = alignmentGuides
    }
}

extension PracticeView {
    class ViewModel: BaseViewModel {
        
        var lessonModel: LessonModel!
        
        @Published var title: String = ""
        
        @Published var textCellVMlist: [TextCell.ViewModel] = []
        
        @Published var answerCellVMList: [AnswerTextCell.ViewModel] = []
        
        func fetch() {
            let text = "SwiftUI is a modern framework ______ introdu by Apple for building user interfaces"
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
            
            self.textCellVMlist = list
        }
        
        func fetchAnswers() {
            let components = ["Correct", "Dummy1", "Dummy2", "Dummy3"]
            
            var dict: [AnyHashable : AnswerTextCell.ViewModel] = [:]
            var list: [AnswerTextCell.ViewModel] = []
            let count = components.count
            for i in 0 ..< count {
                let component = components[i]
                let cellVM = AnswerTextCell.ViewModel(container: container)
                cellVM.text = component
                cellVM.index = i
                dict[cellVM.id] = cellVM
                list.append(cellVM)
            }
            
            self.answerCellVMList = list
        }
        
        static func viewModel(container: DIContainer, lessonModel: LessonModel) -> ViewModel {
            let vm = ViewModel(container: container)
            vm.lessonModel = lessonModel
            
            vm.title = lessonModel.title
            
            vm.fetch()
            vm.fetchAnswers()
            
            return vm
        }
    }
}

#Preview {
    PracticeView(viewModel: .init(container: .preview))
}
