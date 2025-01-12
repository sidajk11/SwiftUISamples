//
//  MultipartFormCreator.swift
//  EnPractice
//
//  Created by 정영민 on 6/13/24.
//

import Foundation

class MultipartFormCreator {
    private var boundary: String
    private var formDataArray: [FormData]

    init(formDataArray: [FormData]) {
        self.boundary = UUID().uuidString
        self.formDataArray = formDataArray
    }

    func createBody() -> Data {
        var body = Data()

        for formData in formDataArray {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            if let fileName = formData.fileName {
                body.append("Content-Disposition: form-data; name=\"\(formData.name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            } else {
                body.append("Content-Disposition: form-data; name=\"\(formData.name)\"\r\n".data(using: .utf8)!)
            }
            if let mimeType = formData.mimeType {
                body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            } else {
                body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            }
            body.append(formData.data)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }

    func formDataHeader() -> (key: String, value: String) {
        return ("Content-Type", "multipart/form-data; boundary=\(boundary)")
    }
}

struct FormData {
    var name: String = ""
    var data: Data = Data()
    var fileName: String?
    var mimeType: String?
    
    init(name: String, data: Data, fileName: String? = nil, mimeType: String? = nil) {
        self.name = name
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
