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
    
    private func makeJokeURL() -> URL {
        let baseURL = "https://v2.jokeapi.dev/joke/"
        var categories = [String]()
        
        for category in CategoriesMenu.categories {
            if category == "Any category" {
                categories.append("Any")
            } else {
                categories.append(category)
            }
        }
        
        let categoriesString = categories.joined(separator: ",")
        let urlString = baseURL + categoriesString + "?type=twopart"
        guard let url = URL(string: urlString) else {
            fatalError("Cannot make url")
        }
        
        return url
    }
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    
    func loadJoke(handler: @escaping (Result<JokeModel, Error>) -> Void) {
        let url = makeJokeURL()
        print(url)
        networkClient.fetch(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    print(String(decoding: data, as: UTF8.self))
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
