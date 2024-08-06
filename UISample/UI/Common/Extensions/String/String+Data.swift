//
//  String+Data.swift
//  ReelChat
//
//  Created by 정영민 on 2024/03/21.
//

import UIKit

extension String {
    func toUtf8Data() -> Data {
        return self.data(using: String.Encoding.utf8) ?? Data()
    }
}
