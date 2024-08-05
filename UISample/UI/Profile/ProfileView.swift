//
//  ProfileView.swift
//  UISample
//
//  Created by 정영민 on 2024/06/13.
//

import SwiftUI

extension ProfileView {
    enum Route: Routable {
        case edit
        case detail
    }
    
    @ViewBuilder private func routing(route: Route) -> some View {
        switch route {
        case .edit:
            ProfileEditView()
        case .detail:
            ProfileDetailView()
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject private var appRootManager: AppRootManager
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var navRouter = NavigationRouter()
    
    @ObservedObject var presentRouter = PresentRouter<Route>()
    
    var body: some View {
        NavigationStack(path: $navRouter.path) {
            content
        }
        .environmentObject(navRouter)
    }
    
    var content: some View {
        VStack {
            CloseButton {
                //presentationMode.wrappedValue.dismiss()
                appRootManager.currentRoot = .intro
            }
            
            Button("Show Edit") {
                presentRouter.fullScreenCover(route: .edit)
            }
            
            Button("Show Profile") {
                navRouter.push(route: Route.detail)
            }
            
        }
        .navigationDestination(for: Route.self) { route in
            routing(route: route)
        }
        .fullScreenCover(item: $presentRouter.fullScreen) { route in
            routing(route: route)
        }
    }
}

#Preview {
    ProfileView()
}
