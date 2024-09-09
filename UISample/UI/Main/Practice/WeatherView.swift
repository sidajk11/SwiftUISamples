//
//  WeatherView.swift
//  UISample
//
//  Created by 정영민 on 2024/08/19.
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
    @Environment(\.presentationMode) var presentationMode
    
    let viewModel: ViewModel
    
    var body: some View {
        
        contentZStack
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left") // Custom back button icon
                            Text("Back") // Custom back button text
                        }
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                routing(for: route)
            }
            .onAppear {
                self.viewModel.onAppear()
            }
    }
    
    var contentZStack: some View {
        HStack() {
            ZStack(alignment: .topLeading) {
                Text("🌧")
                    .frame(height: 24)
                    .alignmentGuide(.leading) { d in
                        0
                    }
                    .offset(CGSize(width: 0, height: 0))
                    .border(.gray)
                Text("Rain & Thunderstorms")
                    .frame(height: 24)
                    .border(.gray)
                    .alignmentGuide(.leading) { d in
                        -24
                    }
                Text("⛈")
                    .frame(height: 24)
                    .alignmentGuide(.leading) { d in //d[VerticalAlignment.center].distance(to: -10)
                        -100
                    }
                    .border(.gray)
                Rectangle().frame(width: 40, height: 100)
                    .alignmentGuide(.leading) { d in //d[VerticalAlignment.center].distance(to: -10)
                        -124
                    }
                    .border(.red)
                    .foregroundStyle(.blue)
            }
            .border(.green)
            
            Spacer()
        }
    }
    
    var content: some View {
        VStack {
            Text("Today's Weather")
                .font(.title)
                .border(.gray)

            HStack(alignment: VerticalAlignment.top) {
                Text("🌧")
                    .frame(height: 24)
                    .alignmentGuide(.top) { d in
                        -10//d[.bottom] + 0
                    }
                    .offset(CGSize(width: 0, height: 0))
                    .border(.gray)
                Text("Rain & Thunderstorms")
                    .frame(height: 24)
                    .border(.gray)
                    .alignmentGuide(.bottom) { d in
                        0//d[.bottom] + 0
                    }
                Text("⛈")
                    .frame(height: 24)
                    .alignmentGuide(VerticalAlignment.center) { d in //d[VerticalAlignment.center].distance(to: -10)
                        10//d[VerticalAlignment.center] + 0
                    }
                    .border(.gray)
                Rectangle().frame(width: 40, height: 100)
                    .border(.red)
                    .foregroundStyle(.blue)
                    
            }
            .border(.green)
            
            HStack(alignment: VerticalAlignment.center) {
                Text("🌧")
                    .frame(height: 24)
                    .alignmentGuide(.top) { d in
                        0//d[.bottom] + 0
                    }
                    .offset(CGSize(width: 0, height: 0))
                    .border(.gray)
                Text("Rain & Thunderstorms")
                    .frame(height: 24)
                    .border(.gray)
                    .alignmentGuide(.bottom) { d in
                        0//d[.bottom] + 0
                    }
                Text("⛈")
                    .frame(height: 24)
                    .alignmentGuide(VerticalAlignment.center) { d in //d[VerticalAlignment.center].distance(to: -10)
                        0//d[VerticalAlignment.center] + 0
                    }
                    .border(.gray)
                Rectangle().frame(width: 40, height: 100)
                    .border(.red)
                    .foregroundStyle(.blue)
                    
            }
            .border(.green)
            
            HStack(alignment: VerticalAlignment.bottom) {
                Text("🌧")
                    .frame(height: 24)
                    .alignmentGuide(.top) { d in
                        0//d[.bottom] + 0
                    }
                    .offset(CGSize(width: 0, height: 0))
                    .border(.gray)
                Text("Rain & Thunderstorms")
                    .frame(height: 24)
                    .border(.gray)
                    .alignmentGuide(.bottom) { d in
                        48//d[.bottom] + 0
                    }
                Text("⛈")
                    .frame(height: 24)
                    .alignmentGuide(VerticalAlignment.center) { d in //d[VerticalAlignment.center].distance(to: -10)
                        0//d[VerticalAlignment.center] + 0
                    }
                    .border(.gray)
                Rectangle().frame(width: 40, height: 100)
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

