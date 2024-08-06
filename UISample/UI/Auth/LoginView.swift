//
//  LoginView.swift
//  UISample
//
//  Created by 정영민 on 2024/05/31.
//

import SwiftUI

extension LoginView {
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


struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let viewModel: ViewModdel
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var geometrySize: CGSize = .zero
    @FocusState private var focusedField: Field?
    
    @FocusState private var test: Int?
    
    enum Field: Int, Hashable {
        case username, password
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView {
                ScrollViewReader { proxy in
                    content
                        .onChange(of: focusedField) { field in
                            withAnimation {
                                if let field = field {
                                    proxy.scrollTo(field, anchor: .center)
                                }
                            }
                        }
                        .gesture(
                            TapGesture()
                                .onEnded { _ in
                                    UIApplication.shared.endEditing()
                                }
                        )
                        .onAppear {
                            self.geometrySize = geometry.size
                            viewModel.$isLogined
                                .receive(on: RunLoop.main)
                                .sink { _ in
                                    
                                }
                                .store(in: viewModel.cancelBag)
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
            closeButton
            
            Text("Geometry Width: \(geometrySize.width)")
                .padding(.bottom, 400)
            
            userIdTextField
            
            passwordTextField
            
            loginButton
        }
        .padding()
    }
    
    var loginButton: some View {
        Button(action: {
            print("Username: \(username), Password: \(password)")
            //username = Bool.random() ? "test" : ""
            viewModel.login(username: username, password: password)
            //navRouter.push(route: Route.main)
        }) {
            Text("Login")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }
    
    var passwordTextField: some View {
        SecureField("Password", text: $password)
            .focused($focusedField, equals: .password)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .textInputAutocapitalization(.never)
            .id(Field.password)
    }
    
    var userIdTextField: some View {
        TextField("Username", text: $username)
            .focused($focusedField, equals: .username)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .textInputAutocapitalization(.never)
            .id(Field.username)
    }
    
    var closeButton: some View {
        HStack() {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
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

extension LoginView {
    class ViewModdel: BaseViewModel {
        @Published var isLogined: Bool = false
        
        required init(container: DIContainer) {
            super.init(container: container)
            
            let appState = container.appState
            appState.map(\.userData.isLogined)
                .removeDuplicates()
                .weakAssign(to: \.isLogined, on: self)
                .store(in: cancelBag)
        }
        
        func login(username: String, password: String) {
            container.services.loginService.login(username: username, password: password)
                .sinkToResult { result in
                    if case .success(let model) = result {
                        let token = model.access_token
                        //self.container.appState.value.userData.token = token  -> Won't report event
                        self.container.appState[\.userData.token] = token
                        self.isLogined = true
                    }
                }.store(in: cancelBag)
        }
    }
}


#Preview {
    LoginView(viewModel: .init(container: .preview))
}
