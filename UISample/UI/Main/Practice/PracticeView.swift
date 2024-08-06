//
//  PracticeView.swift
//  UISample
//
//  Created by 정영민 on 2024/08/05.
//

import SwiftUI

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
    
    let viewModel: ViewModel
    
    @State private var geometrySize: CGSize = .zero
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
        ScrollView {
            VStack {
                Text(viewModel.title)
            }
        }
        .navigationDestination(for: Route.self) { route in
            routing(for: route)
        }
    }
}

extension PracticeView {
    class ViewModel: BaseViewModel {
        
        var lessonModel: LessonModel!
        
        @Published var title: String = ""
        
        func onAppear() {
            
        }
        
        static func viewModel(container: DIContainer, lessonModel: LessonModel) -> ViewModel {
            let vm = ViewModel(container: container)
            vm.lessonModel = lessonModel
            
            vm.title = lessonModel.title
            
            return vm
        }
    }
}

#Preview {
    PracticeView(viewModel: .init(container: .preview))
}
