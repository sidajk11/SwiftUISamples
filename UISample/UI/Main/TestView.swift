//
//  TestView.swift
//  UISample
//
//  Created by 정영민 on 2024/07/26.
//

import SwiftUI

extension TestView {
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

struct TestView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let viewModel: ViewModdel
    
    @ObservedObject var presentRouter = PresentRouter<Route>()
    
    @State private var showingMainSheet = false
    @State private var showingSubSheet = false
    @State private var presentingFullScreenCover = false
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack {
            Text("Hello, World!")
            
            closeButton
            
            Button("Show Turm") {
                presentRouter.sheet(route: .term)
            }
            
            Button("Show Privacy") {
                presentRouter.sheet(route: .privacy(message: "this is message"))
            }
            
            Button("Show PresentingView") {
                presentRouter.fullScreenCover(route: .full)
            }
            
            Button("Show Setting") {
                viewModel.navRouter.push(route: Route.setting)
            }
            
            Button("Show Profile") {
                presentRouter.fullScreenCover(route: .profile)
            }
        }
        .sheet(item: $presentRouter.sheet, content: { route in
            routing(route: route)
        })
        .fullScreenCover(item: $presentRouter.fullScreen) { route in
            routing(route: route)
        }
        .navigationDestination(for: Route.self) { route in
            routing(route: route)
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

extension TestView {
    class ViewModdel: BaseViewModel {
        required init(container: DIContainer, navRouter: NavigationRouter? = nil) {
            super.init(container: container, navRouter: navRouter)
        }
    }
}

#Preview {
    TestView(viewModel: .preview)
}

