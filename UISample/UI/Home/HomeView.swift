//
//  HomeView.swift
//  UISample
//
//  Created by 정영민 on 2024/08/01.
//

import SwiftUI

extension HomeView {
    enum Route: Routable {
        case term
        case privacy(message: String)
        case full
        case setting
        case practice(cellVM: LessonCell.ViewModel)
    }
    
    @ViewBuilder private func routing(route: Route) -> some View {
        NavigationStack(path: $navRouter.path) {
            switch route {
            case .term:
                SheetView()
            case .privacy(let message):
                SubSheetView(text: message)
            case .full:
                PresentingView()
            case .setting:
                SettingView()
            case .practice(let cellVM):
                if let lessonModel = cellVM.lessonModel {
                    PracticeView(viewModel: PracticeView.ViewModel.viewModel(container: viewModel.container, lessonModel: lessonModel))
                }
            }
        }
        .environmentObject(navRouter)
    }
}

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var showingMainSheet = false
    @State private var showingSubSheet = false
    @State private var presentingFullScreenCover = false
    
    @StateObject var navRouter = NavigationRouter()
    @StateObject var presentRouter = PresentRouter<Route>()
    
    var body: some View {
        content
            .onAppear {
                viewModel.fetch()
            }
    }
    
    var content: some View {
        VStack {
            List(selection: $viewModel.selectedLesson) {
                ForEach(viewModel.units) { unitModel in
                    Section(header: Text(unitModel.title)) {
                        ForEach(viewModel.lessons(unitNo: unitModel.unitNo)) { cellVM in
                            LessonCell(viewModel: cellVM)
                        }
                    }
                }
            }
            .onChange(of: viewModel.selectedLesson, perform: { newValue in
                guard let newValue = newValue else { return }
                guard let model = viewModel.lesson(by: newValue) else { return }
                presentRouter.fullScreenCover(route: Route.practice(cellVM: model))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    viewModel.selectedLesson = nil
                }

            })
        }
        .fullScreenCover(item: $presentRouter.fullScreen) { route in
            routing(route: route)
        }
    }
}

extension HomeView {
    class ViewModel: BaseViewModel {
        
        @Published var units: [UnitModel] = []
        
        var lessonsDict: [Int : [LessonCell.ViewModel]] = [:]
        
        @Published var selectedLesson: LessonCell.ViewModel.ID?
        
        func lessons(unitNo: Int) -> [LessonCell.ViewModel] {
            return lessonsDict[unitNo] ?? []
        }
        
        func fetch() {
            loadTest()
        }
        
        func lesson(by id: LessonCell.ViewModel.ID?) -> LessonCell.ViewModel? {
            for unit in units {
                let lessons = lessonsDict[unit.unitNo] ?? []
                for lesson in lessons {
                    if lesson.id == id {
                        return lesson
                    }
                }
            }
            return nil
        }
        
        private func loadTest() {
            var list: [UnitModel] = []
            for i in 0 ..< 20 {
                let uuid = UUID()
                let unitNo = i + 1
                let unitModel = UnitModel(id: uuid, levelNo: 1, unitNo: unitNo, title: "Unit \(unitNo)", desc: "desc", imageUrl: "")
                list.append(unitModel)
                
                var cellVMList: [LessonCell.ViewModel] = []
                let lessons = loadLessonsTest(unitNo: unitNo)
                for lesson in lessons {
                    let cellVM = LessonCell.ViewModel(baseViewModel: self)
                    cellVM.load(model: lesson)
                    cellVMList.append(cellVM)
                }
                
                lessonsDict[unitNo] = cellVMList
            }
            units = list
        }
        
        private func loadLessonsTest(unitNo: Int) -> [LessonModel] {
            var list: [LessonModel] = []
            for i in 0 ..< 10 {
                let uuid = UUID()
                let lessonNo = i + 1
                let lessonModel = LessonModel(levelNo: 1, unitNo: unitNo, id: uuid, lessonNo: lessonNo, title: "Lesson \(lessonNo)", desc: "desc")
                list.append(lessonModel)
            }
            return list
        }
    }
}

#Preview {
    HomeView(viewModel: .preview)
}
