//
//  String+Dictionary.swift
//  ReelChat
//
//  Created by 정영민 on 2024/07/15.
//

import Foundation

extension String {
    /// Converting object to postable dictionary
    func toDictionary() -> [AnyHashable: Any] {
        do {
            let data = toUtf8Data()
            let object = try JSONSerialization.jsonObject(with: data)
            if let json = object as? [AnyHashable: Any] {
                return json
            } else {
                return [:]
            }
        } catch {
            return [:]
        }
    }
}
