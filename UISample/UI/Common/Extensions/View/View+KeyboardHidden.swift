//
//  View+KeyboardHidden.swift
//  UISample
//
//  Created by 정영민 on 2024/08/23.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
