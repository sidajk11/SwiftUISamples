//
//  IntroView.swift
//  EnPractice
//
//  Created by 정영민 on 2024/07/24.
//

import SwiftUI

extension IntroView {
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


struct IntroView: View {
    @EnvironmentObject private var appRootManager: AppRootManager
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: ViewModel
    @State private var geometrySize: CGSize = .zero
    
    var body: some View {
        
        content
            .onAppear {
                self.viewModel.onAppear()
            }
    }
    
    var content: some View {
        VStack(spacing: 20) {
            Button("Show Main") {
                appRootManager.currentRoot = .main
            }
        }
        .padding()
    }
}

extension IntroView {
    class ViewModel: BaseViewModel {
        struct Dependency {
            let container: DIContainer
            
            static var preview: Self {
                return .init(container: .preview)
            }
        }
        
        let dependency: Dependency
        
        required init(dependency: Dependency) {
            self.dependency = dependency
        }
        
        private var isLogined: Bool {
            return dependency.container.appState.value.userData.isLogined
        }
        
        func onAppear() {
        }
    }
}


#Preview {
    IntroView(viewModel: .init(dependency: .preview))
}
