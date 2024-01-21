//
//  JokeFactory.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 21.01.2024.
//

import Foundation

final class JokeFactory: JokeFactoryProtocol {
    let jokesLoader: JokesLoaderProtocol
    let delegate: JokeFactoryDelegateProtocol?
    
    private var joke: JokeModel?
    
    
    init(delegate: JokeFactoryDelegateProtocol?, jokesLoader: JokesLoaderProtocol) {
        self.delegate = delegate
        self.jokesLoader = jokesLoader
    }
    
    
    func loadJoke() {
        jokesLoader.loadJoke { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let jokeModel):
                    self.joke = jokeModel
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestJoke() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.didReceiveNextJoke(joke: self.joke)
        }
    }
}
