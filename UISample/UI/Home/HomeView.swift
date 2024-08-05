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
        case profile
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
        case .profile:
            ProfileView()
        }
    }
}

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: ViewModel
    
    @ObservedObject var presentRouter = PresentRouter<Route>()
    
    @State private var showingMainSheet = false
    @State private var showingSubSheet = false
    @State private var presentingFullScreenCover = false
    
    var body: some View {
        content
            .onAppear {
                viewModel.fetch()
            }
    }
    
    var content: some View {
        VStack {
            List {
                ForEach(viewModel.units) { unitModel in
                    Section(header: Text(unitModel.title)) {
                        ForEach(viewModel.lessons(unitNo: unitModel.unitNo)) { lessonModel in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(lessonModel.title)
                                        .font(.headline)
                                    Text(lessonModel.desc)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    var closeButton: some View {
        HStack() {
            Button(action: {
                //presentationMode.wrappedValue.dismiss()
                viewModel.navRouter.popup(2)
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.6))
                    .clipShape(Circle())
            }
            .padding()
            Spacer()
        }
    }
}

extension HomeView {
    class ViewModel: BaseViewModel {
        
        @Published var units: [UnitModel] = []
        
        var lessonsDict: [Int : [LessonModel]] = [:]
        
        required init(container: DIContainer, navRouter: NavigationRouter? = nil) {
            super.init(container: container, navRouter: navRouter)
        }
        
        func lessons(unitNo: Int) -> [LessonModel] {
            return lessonsDict[unitNo] ?? []
        }
        
        func fetch() {
            loadTest()
        }
        
        private func loadTest() {
            var list: [UnitModel] = []
            for i in 0 ..< 20 {
                let uuid = UUID().uuidString
                let unitNo = i + 1
                let unitModel = UnitModel(id: uuid, levelNo: 1, unitNo: unitNo, title: "Unit \(unitNo)", desc: "desc", imageUrl: "")
                list.append(unitModel)
                
                let lessons = loadLessonsTest(unitNo: unitNo)
                lessonsDict[unitNo] = lessons
            }
            units = list
        }
        
        private func loadLessonsTest(unitNo: Int) -> [LessonModel] {
            var list: [LessonModel] = []
            for i in 0 ..< 10 {
                let uuid = UUID().uuidString
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
