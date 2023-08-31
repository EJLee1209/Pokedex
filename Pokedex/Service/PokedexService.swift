//
//  PokedexService.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import Foundation
import Combine

class PokedexService: PokedexServiceType {
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private var pokemonList: [Pokemon] = []
    var pokemonListPublisher: CurrentValueSubject<[Pokemon], Never> = .init([])
    
    private var nextUrl: String? = nil
    
    init() {
        
        fetchFirstPokedexResponse()
            .sink { completion in
                print(completion)
                
            } receiveValue: { response in
                // 다음 페이지 url 저장
                self.nextUrl = response.next
                
                response.results.forEach { result in
                    self.fetchPokemon(result: result)
                        .sink { completion in
                            
                        } receiveValue: { pokemon in
                            self.pokemonList.append(pokemon)
                            self.pokemonListPublisher.send(self.pokemonList)
                        }.store(in: &self.cancellables)
                }
            }.store(in: &cancellables)

    }
    
    func fetchFirstPokedexResponse() -> AnyPublisher<PokedexResponse, Error> {
        let url = "https://pokeapi.co/api/v2/pokemon/"
        return httpRequestPublisher(for: url, decodeType: PokedexResponse.self).eraseToAnyPublisher()
    }
    
    func fetchNextPokedexResponse() {
        guard let nextUrl = nextUrl else {
            return
        }
        httpRequestPublisher(for: nextUrl, decodeType: PokedexResponse.self)
            .eraseToAnyPublisher()
            .sink { _ in
                
            } receiveValue: { response in
                // 다음 페이지 url 저장
                self.nextUrl = response.next
                
                response.results.forEach { result in
                    self.fetchPokemon(result: result)
                        .sink { completion in
                            
                        } receiveValue: { pokemon in
                            self.pokemonList.append(pokemon)
                            self.pokemonListPublisher.send(self.pokemonList)
                        }.store(in: &self.cancellables)
                }
            }.store(in: &cancellables)
    }
    
    func fetchPokemon(result: PokedexResponse.PokedexResult) -> AnyPublisher<Pokemon, Error> {
        return httpRequestPublisher(for: result.url, decodeType: Pokemon.self).eraseToAnyPublisher()
    }
    
}
