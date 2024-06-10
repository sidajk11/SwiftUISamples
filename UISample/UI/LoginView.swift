//
//  LoginView.swift
//  UISample
//
//  Created by 정영민 on 2024/05/31.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
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
                        }
                }
            }
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
            username = Bool.random() ? "test" : ""
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
            .id(Field.password)
    }
    
    var userIdTextField: some View {
        TextField("Username", text: $username)
            .focused($focusedField, equals: .username)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
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


#Preview {
    LoginView()
}
