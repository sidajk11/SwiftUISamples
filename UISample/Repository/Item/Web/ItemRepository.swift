//
//  ItemWebRepository.swift
//  UISample
//
//  Created by 정영민 on 6/13/24.
//

import Combine
import Foundation

protocol ItemWebRepository: WebRepository {
    func loadItems() -> AnyPublisher<[ItemModel], Error>
}

struct RealItemWebRepository: ItemWebRepository {
    
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func loadItems() -> AnyPublisher<[ItemModel], Error> {
        return call(endpoint: API.allItems)
    }
}
