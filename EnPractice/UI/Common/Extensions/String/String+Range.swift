//
//  String+Range.swift
//  ReelChat
//
//  Created by 정영민 on 2024/05/27.
//

import UIKit

extension String {
    func range(of string: String) -> NSRange {
        return (string as NSString).range(of: string)
    }
}
