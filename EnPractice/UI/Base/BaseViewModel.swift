//
//  BaseViewModel.swift
//  EnPractice
//
//  Created by 정영민 on 7/20/24.
//

import SwiftUI
import Combine

protocol BaseViewModel: ObservableObject, Identifiable {
    associatedtype Dependency

    var dependency: Dependency { get }

    init(dependency: Dependency)
}
