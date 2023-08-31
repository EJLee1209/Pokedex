//
//  PokedexService.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import Foundation
import Combine

protocol PokedexServiceType {
    
    var pokemonListPublisher: CurrentValueSubject<[Pokemon], Never> { get }
    
    func fetchFirstPokedexResponse() -> AnyPublisher<PokedexResponse, Error>
    func fetchNextPokedexResponse()
}

extension PokedexServiceType {
    
    func httpRequestPublisher<T:Decodable>(for endPoint: String, decodeType: T.Type) -> AnyPublisher<T, Error> {
        let url = URL(string: endPoint)!
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
