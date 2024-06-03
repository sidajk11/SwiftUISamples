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
    
    enum Field: Int, Hashable {
        case username, password
    }

    var body: some View {
        
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ZStack(alignment: .top) {
                    ScrollView {
                        content
                    }
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
                }
                .onAppear {
                    self.geometrySize = geometry.size
                }
            }
        }
    }
    
    var content: some View {
        VStack(spacing: 20) {
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
            
            Text("Geometry Width: \(geometrySize.width)")
                .padding(.bottom, 400)
            
            TextField("Username", text: $username)
                .focused($focusedField, equals: .username)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .id(Field.username)

            SecureField("Password", text: $password)
                .focused($focusedField, equals: .password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .id(Field.password)

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
        .padding()
    }
}


#Preview {
    LoginView()
}
