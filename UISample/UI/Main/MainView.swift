//
//  MainView.swift
//  UISample
//
//  Created by 정영민 on 2024/06/11.
//

import SwiftUI

extension MainView {
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

struct MainView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let viewModel: ViewModel
    
    @ObservedObject var presentRouter = PresentRouter<Route>()
    
    @State private var showingMainSheet = false
    @State private var showingSubSheet = false
    @State private var presentingFullScreenCover = false
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: .init(baseViewModel: viewModel))
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                .tag(0)

            SettingView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
                .tag(1)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
        // Custom Tab Bar
        HStack {
            Button(action: {
                selectedTab = 0
            }) {
                VStack {
                    Image(systemName: "house")
                    Text("Home")
                }
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                selectedTab = 1
            }) {
                VStack {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                selectedTab = 2
            }) {
                VStack {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(UIColor.systemBackground).shadow(radius: 2))
    }
}

extension MainView {
    class ViewModel: BaseViewModel {
        required init(container: DIContainer) {
            super.init(container: container)
        }
    }
}

#Preview {
    MainView(viewModel: .preview)
}
