//
//  Callback.swift
//  EnPractice
//
//  Created by 정영민 on 2024/08/16.
//

import Foundation

typealias Callback = () -> Void
typealias CallbackResult<T> = (_ value: T) -> Void
