//
//  MainView.swift
//  UISample
//
//  Created by 정영민 on 2024/06/11.
//

import SwiftUI

extension MainView {
    enum Route: Routable {
        case sheet
        case sheetSub(message: String)
        case full
        case setting
    }
    
    @ViewBuilder private func routing(route: Route) -> some View {
        switch route {
        case .sheet:
            SheetView()
        case .sheetSub(let message):
            SubSheetView(text: message)
        case .full:
            PresentingView()
        case .setting:
            SettingView()
                .environmentObject(navRouter)
        }
    }
}

struct MainView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var navRouter: NavigationRouter
    
    @ObservedObject var presentRouter = PresentRouter<Route>()
    
    @State private var showingMainSheet = false
    @State private var showingSubSheet = false
    @State private var presentingFullScreenCover = false
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            
            closeButton
            
            Button("Show Sheet") {
                presentRouter.sheet(route: .sheet)
            }
            
            Button("Show Sub Sheet") {
                presentRouter.sheet(route: .sheetSub(message: "this is message"))
            }
            
            Button("Show PresentingView") {
                presentRouter.fullScreenCover(route: .full)
            }
            
            Button("Show Setting") {
                navRouter.push(route: Route.setting)
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
                navRouter.popup(2)
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

#Preview {
    MainView()
}
