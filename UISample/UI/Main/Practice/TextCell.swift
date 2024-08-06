//
//  TextCell.swift
//  UISample
//
//  Created by 정영민 on 2024/08/06.
//

import SwiftUI

extension TextCell {
    enum Route: Routable {
        case main
    }
    
    // Builds the views
    @ViewBuilder func routing(for route: Route) -> some View {
        switch route {
        case .main:
            MainView(viewModel: .init(baseViewModel: viewModel))
        }
    }
}

struct TextCell: View {
    let viewModel: ViewModel
    
    var body: some View {
        content
            .navigationDestination(for: Route.self) { route in
                routing(for: route)
            }
            .onAppear {
                self.viewModel.onAppear()
            }
    }
    
    var content: some View {
        ScrollView {
            VStack {
                Text(viewModel.text)
            }
        }
    }
}

extension TextCell {
    class ViewModel: BaseViewModel {
        var text: String = ""
        var size: CGSize = .init(width: 20, height: 20)
        var index: Int = 0
        
        func onAppear() {
        }
    }
}


#Preview {
    TextCell(viewModel: .init(container: .preview))
}
