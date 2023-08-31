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
                
            } receiveValue: { [weak self] response in
                self?.makePokemonListUseResponse(response)
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
                
            } receiveValue: { [weak self] response in
                self?.makePokemonListUseResponse(response)
            }.store(in: &cancellables)
    }
    
    private func fetchPokemon(result: PokedexResponse.PokedexResult) -> AnyPublisher<Pokemon, Error> {
        return httpRequestPublisher(for: result.url, decodeType: Pokemon.self).eraseToAnyPublisher()
    }
    
    private func makePokemonListUseResponse(_ response: PokedexResponse) {
        // 다음 페이지 url 저장
        self.nextUrl = response.next
        
        response.results.forEach { result in
            self.fetchPokemon(result: result)
                .sink { completion in
                    
                } receiveValue: { [weak self] pokemon in
                    guard let self = self else { return }
                    self.pokemonListPublisher.value.append(pokemon)
                    self.pokemonListPublisher.value.sort(by: { $0.id < $1.id })
                }.store(in: &self.cancellables)
        }
    }
    
}
