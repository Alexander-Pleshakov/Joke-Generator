//
//  JokesLoader.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 21.01.2024.
//

import Foundation

struct JokesLoader: JokesLoaderProtocol {
    private let networkClient: NetworkClientProtocol
    
    private var jokeURL: URL {
        guard let url = URL(string: "https://official-joke-api.appspot.com/jokes/random") else {
            preconditionFailure("Unable to construct jokeURL")
        }
        return url
    }
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    
    func loadJoke(handler: @escaping (Result<JokeModel, Error>) -> Void) {
        networkClient.fetch(url: jokeURL) { result in
            switch result {
            case .success(let data):
                do {
                    let joke = try JSONDecoder().decode(JokeModel.self, from: data)
                    handler(.success(joke))
                }
                catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    
    
}
