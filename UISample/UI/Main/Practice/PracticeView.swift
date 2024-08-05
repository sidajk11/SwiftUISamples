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
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.items, id: \.self) { item in
                    Text(item)
                        .frame(width: 100, height: 100)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
        .navigationDestination(for: Route.self) { route in
            routing(for: route)
        }
    }
    
    var content: some View {
        VStack(spacing: 20) {
        }
        .padding()
    }
}

extension PracticeView {
    class ViewModel: BaseViewModel {
        
        var columns: [String] = []
        var items: [String] = []
        
        private var isLogined: Bool {
            return container.appState.value.userData.isLogined
        }
        
        func onAppear() {
            if isLogined {
                self.navRouter.push(route: Route.main)
            }
            
            for i in 0 ..< 20 {
                columns.append("\(i)")
            }
            
            for i in 0 ..< 10 {
                items.append("item \(i)")
            }
        }
    }
}

#Preview {
    PracticeView(viewModel: .init(container: .preview))
}
