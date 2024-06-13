//
//  CountyRepository.swift
//  UISample
//
//  Created by 정영민 on 6/13/24.
//

import Combine
import Foundation

protocol CountriesWebRepository: WebRepository {
    func loadCountries() -> AnyPublisher<[Country], Error>
    func loadCountryDetails(country: Country) -> AnyPublisher<Country.Details.Intermediate, Error>
}

struct RealCountriesWebRepository: CountriesWebRepository {
    
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func loadCountries() -> AnyPublisher<[Country], Error> {
        return call(endpoint: API.allCountries)
    }

    func loadCountryDetails(country: Country) -> AnyPublisher<Country.Details.Intermediate, Error> {
        let request: AnyPublisher<[Country.Details.Intermediate], Error> = call(endpoint: API.countryDetails(country))
        return request
            .tryMap { array -> Country.Details.Intermediate in
                guard let details = array.first
                    else { throw APIError.unexpectedResponse }
                return details
            }
            .eraseToAnyPublisher()
    }
}
