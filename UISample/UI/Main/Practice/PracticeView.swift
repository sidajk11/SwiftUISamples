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
    @State private var preferences: [PreferenceSizeData] = []
    
    private let horizontalSpacing: CGFloat = 10
    private let horizontalPadding: CGFloat = 12
    
    @State private var gridHeight: CGFloat = 0

    @State private var alignmentGuides = [AnyHashable: CGPoint]()
    
    var spacePositions: [CGPoint] = []
    
    let cancelBag = CancelBag()

    
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
            AutoLayoutGrid(viewModel.textCellVMlist) { data in
                TextCell(viewModel: data)
                    .readFrameInGlobal { frame in
                        data.frame = frame
                    }
            }
            .padding(.bottom, 100)
            
            AutoLayoutGrid(viewModel.answerCellVMList) { data in
                let cell = ButtonCell(viewModel: data)
                
                cell.isUpdated.sink { () in
                    let position = viewModel.firstSpacePosition()
                    
                    data.viewOffset = position
                }.store(in: cancelBag)
                return TextCellContainer(textCell: cell)
            }
            .animation(.default, value: UUID())
            
            Spacer()
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
        
        @Published var answerCellVMList: [ButtonCell.ViewModel] = []
        
        func firstSpacePosition() -> CGPoint {
            let frame = textCellVMlist.first(where: { $0.text == "_" })?.frame
            var position: CGPoint = .zero
            if let frame = frame {
                position.x = frame.midX
                position.y = frame.midY
            }
            return position
        }
        
        func fetch() {
            let text = "SwiftUI is a modern framework _ introdu by Apple for building user interfaces"
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
            
            var dict: [AnyHashable : ButtonCell.ViewModel] = [:]
            var list: [ButtonCell.ViewModel] = []
            let count = components.count
            for i in 0 ..< count {
                let component = components[i]
                let cellVM = ButtonCell.ViewModel(container: container)
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
