//
//  VocabularyPracticeView.swift
//  EnPractice
//
//  Created by 정영민 on 1/11/25.
//

import SwiftUI

struct VocabularyPracticeView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        content
    }
    
    var content: some View {
        Text("Guide")
    }
}

extension VocabularyPracticeView {
    class ViewModel: BaseViewModel {
        let dependency: Dependency
        
        required init(dependency: Dependency) {
            self.dependency = dependency
        }
    }
}

extension VocabularyPracticeView {
    struct Dependency {
        let container: DIContainer
        let practice: PracticeModel
    }
}


#Preview {
    let model = PracticeModel(levelNo: 1, unitNo: 1, id: UUID(), lessonNo: 1, title: "Preview", desc: "Preview")
    let viewModel = VocabularyPracticeView.ViewModel(dependency: .init(container: .preview, practice: model))
    VocabularyPracticeView(viewModel: viewModel)
}
