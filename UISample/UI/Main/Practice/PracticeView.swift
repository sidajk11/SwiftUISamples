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
            let offset = CGPoint(x: 0 - (width),
                                 y: 0 - (totalHeight))
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
        
        @Published var list: [TextCell.ViewModel] = []
        
        @Published var cellVMList: [AnyHashable : TextCell.ViewModel] = [:]
        
        @Published var itemsArranged: [[TextCell.ViewModel]] = []
        
        func fetch() {
            let text = "SwiftUI is a modern framework ______ introdu by Apple for building user interfaces sfds sdf  dfjfsdsdf dsf jljf jsd fdjsk fdkjl sdfd adsjkf ljsdf ljsadf jdskf sdljf dklsfj asdjfldk fldsf sdl fjds lfjdsfkjsdlfkj sld dlk jfdsjkfsdlkjflasdjf lsdfldsjfldsjf lsdjf sadljf jds fkjldsljk fsdlkajfl kdsjfl jksdlfj sdljkf sdlak"
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
