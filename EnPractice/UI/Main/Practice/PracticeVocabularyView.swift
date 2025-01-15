//
//  PracticeVocabularyView.swift
//  EnPractice
//
//  Created by 정영민 on 1/11/25.
//

import SwiftUI
import Combine

struct PracticeVocabularyView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack {
            Text(viewModel.localWord)
                .font(.h1)
                .padding(.top, 120)
            
            Spacer()
            
            selectionListView
                .padding(.vertical, 124)
            
            
            Button {
            } label: {
                Text("확인")
                    .font(.h2)
            }

        }
    }
    
    var selectionListView: some View {
        LazyHStack(spacing: 48) {
            ForEach(viewModel.selections) { data in
                ZStack {
                    VStack {
                        Text(data.emoji)
                            .font(.system(size: 60, design: .default))
                            .padding()
                        Text(data.enWord)
                            .font(.h1)
                            .padding()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(data.backgroundColor) // 배경 색상
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(data.borderColor, lineWidth: 2) // 테두리
                    )
                    .foregroundColor(data.foregroundColor)
                    
                    Button {
                        viewModel.selected = data
                    } label: {
                        Text("")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                
            }
            .padding()
        }
        .padding()
        .frame(height: 240)
        .border(.appBlue300)
        //.frame(height: 120)
    }
}

extension PracticeVocabularyView {
    class ViewModel: BaseViewModel {
        let dependency: Dependency
        
        @Published var localWord: String
        @Published var selections: [SelectionData] = []
        @Published var selected: SelectionData? = nil
        
        required init(dependency: Dependency) {
            self.dependency = dependency
            localWord = dependency.model.localWord
            
            $selected
                .combineLatest(Just(dependency.model.selectionList))
                .map { selectedData, list in
                    list.map { item in
                        let isSelected = (item.enWord == selectedData?.id)
                        
                        // 색상 정의
                        let foregroundColor: Color = isSelected ? .white : .black
                        let backgroundColor: Color = isSelected ? .appBlue200 : .white
                        let borderColor: Color = isSelected ? .appBlue400 : .appGray900
                        
                        // 새로운 SelectionData 생성
                        return SelectionData(
                            id: item.enWord,
                            emoji: item.imageName,
                            enWord: item.enWord,
                            foregroundColor: foregroundColor,
                            backgroundColor: backgroundColor,
                            borderColor: borderColor
                        )
                    }
                }
                .assign(to: &$selections)
        }
    }
    
    struct SelectionData: Identifiable {
        let id: String
        let emoji: String
        let enWord: String
        let foregroundColor: Color
        let backgroundColor: Color
        let borderColor: Color
        
        static let selectedForgroundColor: Color = .white
        static let selectedBackgroundColor: Color = .appBlue200
        static let selectedBorderColor: Color = .appBlue400
        
        static let normalForgroundColor: Color = .black
        static let normalBackgroundColor: Color = .white
        static let normalBorderColor: Color = .appGray900
    }
}

extension PracticeVocabularyView {
    struct Dependency {
        let container: DIContainer
        let model: VocabularyPracticeModel
    }
}


#Preview {
    let viewModel = PracticeVocabularyView.ViewModel(dependency: .init(container: .preview, model: .preview))
    PracticeVocabularyView(viewModel: viewModel)
}
