//
//  HomeView.swift
//  EnPractice
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
        case practice(unitId: UUID, lessonId: UUID)
    }
    
    @ViewBuilder private func routing(route: Route) -> some View {
        switch route {
        case .term:
            SheetView()
        case .privacy(let message):
            SubSheetView(text: message)
        case .full:
            PresentingView()
        case .setting:
            SettingView()
        case .practice(let unitId, let lessonId):
            if let viewModel = viewModel.practiceInputWordViewModel(unitId: unitId, lessonId: lessonId) {
                PracticeInputWordView(viewModel: viewModel)
            }
        }
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
            List() {
                ForEach(viewModel.unitDataList) { unitData in
                    Section(header: Text(unitData.title)) {
                        ForEach(unitData.lessonList) { data in
                            ZStack {
                                LessonCell(data: data)
                                Button {
                                    presentRouter.fullScreenCover(route: Route.practice(unitId: unitData.id, lessonId: data.id))
                                } label: {
                                }

                            }
                        }
                    }
                }
            }
            
        }
        .onChange(of: viewModel.selectedLessonId, perform: { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                viewModel.selectedLessonId = nil
            }

        })
        .fullScreenCover(item: $presentRouter.fullScreen) { route in
            NavigationStack(path: $navRouter.path) {
                routing(route: route)
            }
            .environmentObject(navRouter)
        }
    }
}

extension HomeView {
    class ViewModel: BaseViewModel {
        struct Dependency {
            let container: DIContainer
            
            static var preview: Self {
                return Self(container: .preview)
            }
        }
        
        let dependency: Dependency
        let cancelBag = CancelBag()
        
        @Published var unitList: [UnitModel] = []
        @Published var lessonListDict: [UUID : [LessonModel]] = [:]
                                        
        @Published var selectedLessonId: UUID?
        @Published var unitDataList: [HomeData.Unit] = []
        
        required init(dependency: Dependency) {
            self.dependency = dependency
            
            $unitList
                .combineLatest($lessonListDict)
                .map { unitList, lessonListDict in
                    var list: [HomeData.Unit] = []
                    for unit in unitList {
                        let lessonList = lessonListDict[unit.id] ?? []
                        let lessonDataList = lessonList.map { lesson in
                            HomeData.Lesson(id: lesson.id, title: lesson.title, desc: lesson.desc)
                        }
                        
                        let unitData = HomeData.Unit(id: unit.id, title: unit.title, lessonList: lessonDataList)
                        list.append(unitData)
                    }
                    return list
                }
                .assign(to: &$unitDataList)
        }
        
        func fetch() {
            loadTest()
        }
        
        func practiceInputWordViewModel(unitId: UUID, lessonId: UUID) -> PracticeInputWordView.ViewModel? {
            let lessons = lessonListDict[unitId]
            guard let lessonModel = lessons?.first(where: { $0.id == lessonId }) else {
                return nil
            }
            return .init(dependency: .init(container: dependency.container, lessonModel: lessonModel))
        }
        
        private func loadTest() {
            var list: [UnitModel] = []
            for i in 0 ..< 20 {
                let uuid = UUID()
                let unitNo = i + 1
                let unitModel = UnitModel(id: uuid, levelNo: 1, unitNo: unitNo, title: "Unit \(unitNo)", desc: "desc", imageUrl: "")
                list.append(unitModel)
                
                let lessons = loadLessonsTest(unitNo: unitModel.unitNo)
                lessonListDict[unitModel.id] = lessons
            }
            unitList = list
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
    HomeView(viewModel: .init(dependency: .preview))
}
