//
//  String+Date.swift
//  ReelChat
//
//  Created by 정영민 on 2024/03/13.
//

import UIKit

extension String {
    func toDate(withFormat format: String = "yyyyMMdd")-> Date?{
        let dateFormatter        = DateFormatter()
        dateFormatter.timeZone   = TimeZone(secondsFromGMT: 0)
        dateFormatter.calendar   = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date                 = dateFormatter.date(from: self)
        return date
    }
    
    func timestampToDate() -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = isoFormatter.date(from: self)
        return date
    }
}
