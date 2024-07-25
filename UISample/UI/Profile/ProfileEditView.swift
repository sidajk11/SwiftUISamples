//
//  ProfileEditView.swift
//  UISample
//
//  Created by 정영민 on 2024/06/13.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            CloseButton {
                presentationMode.wrappedValue.dismiss()
            }
            Text("Profile Edit")
        }
    }
}

#Preview {
    ProfileEditView()
}
