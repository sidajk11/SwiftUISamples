//
//  PracticeCombineView.swift
//  EnPractice
//
//  Created by 정영민 on 2024/08/05.
//

import SwiftUI

extension PracticeCombineView {
    enum Route: Routable {
        case main
        case login
    }
    
    // Builds the views
    @ViewBuilder func routing(for route: Route) -> some View {
        switch route {
        case .login:
            LoginView(viewModel: .init(dependency: .init(container: viewModel.dependency.container)))
        case .main:
            MainView(viewModel: .init(dependency: .init(container: viewModel.dependency.container)))
        }
    }
}


struct PracticeCombineView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: ViewModel
    
    @StateObject var presentRouter = PresentRouter<Route>()
    
    @State private var geometrySize: CGSize = .zero
    @State private var preferences: [PreferenceSizeData] = []
    
    private let horizontalSpacing: CGFloat = 10
    private let horizontalPadding: CGFloat = 12
    
    @State private var gridHeight: CGFloat = 0

    @State private var alignmentGuides = [AnyHashable: CGPoint]()
    
    var spacePositions: [CGPoint] = []
    
    let cancelBag = CancelBag()

    @State private var isShowAlert: Bool = false
    
    @State private var popoverFrame: CGRect = .zero
    
    @State private var popoverText: String = ""
    
    @State private var containerFrameInGlobal: CGRect = .zero
    
    var body: some View {
            //.position(popoverFrame.origin)
            //.frame(width: popoverFrame.width, height: popoverFrame.height)
        
        ZStack(alignment: .topLeading) {
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
                .toastView(isShow: $viewModel.isCorrect)
            
            if !popoverText.isEmpty {
                ZStack {
                    Color.clear
                    ZStack {
                        TranslationPopup(text: $popoverText)
                            .background(.appGray300)
                            .cornerRadius(10)
                            .padding()
                            
                            
                    }
                    .position(CGPoint(x: popoverFrame.center.x, y: popoverFrame.center.y - containerFrameInGlobal.minY + popoverFrame.height))
                }
                .readFrameInGlobal { frame in
                    containerFrameInGlobal = frame
                }
            }
        }
        .border(.red)
        .contentShape(Rectangle())
        .onTapGesture {
            popoverText = ""
        }
    }
    
    var content: some View {
        VStack() {
            sentenceView
            
            answerView
            
            Spacer()
            
            confirmButton
                .padding(.bottom, 24)
        }
    }
    
    var sentenceView: some View {
        AutoLayoutGrid(viewModel.textCellDatalist, alignment: .leading) { data in
            let cell = TextCell(data: data)
                .readFrameInGlobal { frame in
                    data.frameInGlobal = frame
                }
                
            data.action = {
                let text = data.text.trimmingCharacters(in: .punctuationCharacters)
                let translated = viewModel.words[text] ?? ""
                popoverFrame = data.frameInGlobal
                popoverText = translated
                
            }
            return cell
        }
        .padding(.bottom, 100)
        .border(.green)
    }
    
    var answerView: some View {
        AutoLayoutGrid(viewModel.answerCellDataList, alignment: .center) { data in
            let cell = ButtonCell(data: data) {
                let position = viewModel.firstSpacePosition()
                if cell.isMoved {
                    if viewModel.answer.isEmpty {
                        cell.viewOffsetInGlobal = position
                        viewModel.answer = data.text
                    }
                    else {
                        cell.isMoved = false
                    }
                } else {
                    cell.viewOffset = .zero
                    viewModel.answer = ""
                }
            }
            return TextCellContainer(textCell: cell)
        }
    }
    
    var confirmButton: some View {
        Button {
            if viewModel.done {
                presentationMode.wrappedValue.dismiss()
            }
            else {
                viewModel.checkAnswer()
                viewModel.confirmButtonTitle = String(localized: "다음")
                viewModel.done = true
            }
        } label: {
            Text(viewModel.confirmButtonTitle)
                .foregroundStyle(.appGray000)
                .font(.h2)
        }
        .frame(minWidth: 100)
        .padding()
        .background(.appGray600)
        .cornerRadius(10)
    }
}

extension PracticeCombineView {
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

extension PracticeCombineView {
    class ViewModel: BaseViewModel {
        struct Dependency {
            let container: DIContainer
            let lessonModel: LessonModel
            
            static var preview: Self {
                return Self(container: .preview, lessonModel: .preview)
            }
        }
        
        let dependency: Dependency
        
        
        var lessonModel: LessonModel!
        
        @Published var title: String = ""
        
        @Published var textCellDatalist: [TextCell.CellData] = []
        
        @Published var answerCellDataList: [ButtonCell.CellData] = []
        
        @Published var confirmButtonTitle: String = String(localized: "확인")
        
        var answer: String = "" {
            didSet {
                
            }
        }
        
        @Published var isCorrect: Bool = false
        @Published var done: Bool = false
        
        var content: String = "That is a _ restaurant."
        var correctAnswer: String = "famous"
        var options: [String] = ["very", "famous", "thanks", "wallet"]
        var words: [String : String] = ["That" : "그것", "is" : "~이다", "a" : "하나의", "famous" : "유명한", "restaurant" : "레스토랑"]
        var translated: String = "그것은 유명한 레스토랑입니다."
        
        required init(dependency: Dependency) {
            self.dependency = dependency
            
            self.lessonModel = dependency.lessonModel
            
            self.title = lessonModel.title
            
            self.fetch()
            self.fetchAnswers()
        }
        
        func firstSpacePosition() -> CGPoint {
            let frame = textCellDatalist.first(where: { $0.text == "_" })?.frameInGlobal
            var position: CGPoint = .zero
            if let frame = frame {
                position.x = frame.midX
                position.y = frame.midY
            }
            return position
        }
        
        func fetch() {
            let components = content.components(separatedBy: .whitespaces)
            
            var dict: [AnyHashable : TextCell.CellData] = [:]
            var list: [TextCell.CellData] = []
            let count = components.count
            for i in 0 ..< count {
                let component = components[i]
                let cellData = TextCell.CellData()
                if component == "_" {
                    cellData.type = .space
                } else {
                    cellData.text = component
                }
                cellData.index = i
                dict[cellData.id] = cellData
                list.append(cellData)
            }
            
            self.textCellDatalist = list
        }
        
        func fetchAnswers() {
            var dict: [AnyHashable : ButtonCell.CellData] = [:]
            var list: [ButtonCell.CellData] = []
            let count = options.count
            for i in 0 ..< count {
                let component = options[i]
                let cellData = ButtonCell.CellData(text: component, index: i)
                dict[cellData.id] = cellData
                list.append(cellData)
            }
            
            self.answerCellDataList = list
        }
        
        func checkAnswer() {
            if !answer.isEmpty {
                isCorrect = answer == correctAnswer
            } else {
                isCorrect = false
            }
        }
    }
}

#Preview {
    PracticeCombineView(viewModel: .init(dependency: .preview))
}
