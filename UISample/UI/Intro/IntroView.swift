//
//  IntroView.swift
//  UISample
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
            LoginView(viewModel: .init(baseViewModel: viewModel))
        case .main:
            MainView(viewModel: .init(baseViewModel: viewModel))
        }
    }
}


struct IntroView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let viewModel: ViewModel
    
    @State private var geometrySize: CGSize = .zero
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView {
                ScrollViewReader { proxy in
                    content
                        .gesture(
                            TapGesture()
                                .onEnded { _ in
                                    UIApplication.shared.endEditing()
                                }
                        )
                        .onAppear {
                            self.geometrySize = geometry.size
                            self.viewModel.onAppear()
                        }
                }
            }
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

extension IntroView {
    class ViewModel: BaseViewModel {
        private var isLogined: Bool {
            return container.appState.value.userData.isLogined
        }
        
        func onAppear() {
            if isLogined {
                self.navRouter.push(route: Route.main)
            }
        }
    }
}


#Preview {
    IntroView(viewModel: .preview)
}
