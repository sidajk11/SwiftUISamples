//
//  WeatherView.swift
//  UISample
//
//  Created by 정영민 on 2024/08/12.
//

import SwiftUI

extension WeatherView {
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

struct WeatherView: View {
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
        VStack {
            Text("Today's Weather")
                .font(.title)
                .border(.gray)

            HStack(alignment: VerticalAlignment.top) {
                Text("🌧")
                    .alignmentGuide(.bottom) { d in
                        d[.bottom] + 0
                    }
                    .offset(CGSize(width: 0, height: 0))
                    .border(.gray)
                Text("Rain & Thunderstorms")
                    .border(.gray)
                Text("⛈")
                    .alignmentGuide(VerticalAlignment.center) { d in //d[VerticalAlignment.center].distance(to: -10)
                        d[VerticalAlignment.center] + 0
                    }
                    .border(.gray)
                Rectangle().frame(width: 40, height: 40)
                    .alignmentGuide(.top, computeValue: { d in
                        d[VerticalAlignment.top] - 10
                    })
                    .border(.red)
                    .foregroundStyle(.blue)
                    
            }
            .border(.green)
        }
    }
}

extension WeatherView {
    class ViewModel: BaseViewModel {
        
        func onAppear() {
        }
    }
}


#Preview {
    WeatherView(viewModel: .init(container: .preview))
}

