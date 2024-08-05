//
//  UnitView.swift
//  UISample
//
//  Created by 정영민 on 2024/08/01.
//

import SwiftUI

extension UnitView {
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

struct UnitView: View {
    var body: some View {
        ZStack {
            Text("Title")
            Text("Desc")
        }
    }
    
}

extension UnitView {
    class ViewModel: BaseViewModel {
        
        var title: String = ""
        var desc: String = ""
        var unitNo: Int = 0
    }
}

#Preview {
    HomeView(viewModel: .preview)
}
