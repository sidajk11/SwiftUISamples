//
//  LessonCell.swift
//  UISample
//
//  Created by 정영민 on 2024/08/01.
//

import SwiftUI

extension LessonCell {
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


struct LessonCell: View {
    @Environment(\.presentationMode) var presentationMode
    
    let viewModel: ViewModel
    
    var body: some View {
        content
    }
    
    var content: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                Text(viewModel.desc)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension LessonCell {
    class ViewModel: BaseViewModel, Hashable {
        var lessonModel: LessonModel?
        
        var title: String = ""
        var desc: String = ""
        
        func load(model: LessonModel) {
            lessonModel = model
            title = model.title
            desc = model.desc
        }
        
        func onAppear() {
            
        }
        
        static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(lessonModel?.id)
        }
    }
}


#Preview {
    LessonCell(viewModel: .init(container: .preview))
}
