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

    @State private var isShowAlert: Bool = false
    
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
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button {
                        isShowAlert.toggle()
                    } label: {
                        Text("Alert")
                    }

                }
            }
            .toastView(isShow: $viewModel.isShowToast)
    }
    
    var content: some View {
        VStack(alignment: .leading) {
            AutoLayoutGrid(viewModel.textCellVMlist) { data in
                TextCell(viewModel: data)
                    .readFrameInGlobal { frame in
                        data.frameInGlobal = frame
                    }
            }
            .padding(.bottom, 100)
            
            AutoLayoutGrid(viewModel.answerCellVMList) { data in
                let cell = ButtonCell(viewModel: data)
                
                data.action = {
                    let position = viewModel.firstSpacePosition()
                    if data.isMoved {
                        if viewModel.answer.isEmpty {
                            data.viewOffsetInGlobal = position
                            viewModel.answer = data.text
                        }
                        else {
                            data.isMoved = false
                        }
                    } else {
                        data.viewOffset = .zero
                        viewModel.answer = ""
                    }
                }
                return TextCellContainer(textCell: cell)
            }
            .animation(.easeInOut(duration: 0.2), value: UUID())
            
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
        
        var answer: String = "" {
            didSet {
                if !answer.isEmpty {
                    isShowToast = answer == correctAnswer
                } else {
                    isShowToast = false
                }
            }
        }
        
        @Published var isShowToast: Bool = false
        
        var content: String = "That is a _ "//"That is a _ restaurant."
        var correctAnswer: String = "famous"
        var options: [String] = ["very", "famous", "thanks", "wallet"]
        
        func firstSpacePosition() -> CGPoint {
            let frame = textCellVMlist.first(where: { $0.text == "_" })?.frameInGlobal
            var position: CGPoint = .zero
            if let frame = frame {
                position.x = frame.midX
                position.y = frame.midY
            }
            return position
        }
        
        func fetch() {
            let components = content.components(separatedBy: .whitespaces)
            
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
            var dict: [AnyHashable : ButtonCell.ViewModel] = [:]
            var list: [ButtonCell.ViewModel] = []
            let count = options.count
            for i in 0 ..< count {
                let component = options[i]
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
