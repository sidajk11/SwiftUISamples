//
//  DeepLinksHandler.swift
//  UISample
//
//  Created by 정영민 on 2024/06/13.
//
import Foundation

enum DeepLink: Equatable {
    
    case showMain
    
    init?(url: URL) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            components.host == "www.example.com",
            let query = components.queryItems
            else { return nil }
        
        if let item = query.first(where: { $0.name == "Screen" }),
           let screenName = item.value {
            if screenName == "Main" {
                self = .showMain
            }
        }
        return nil
    }
}

// MARK: - DeepLinksHandler

protocol DeepLinksHandler {
    func open(deepLink: DeepLink)
}

struct RealDeepLinksHandler: DeepLinksHandler {
    
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func open(deepLink: DeepLink) {
        switch deepLink {
        case .showMain:
            break
        }
    }
}
