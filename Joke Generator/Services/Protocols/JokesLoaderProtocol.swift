//
//  JokesLoaderProtocol.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 21.01.2024.
//

import Foundation

protocol JokesLoaderProtocol {
    func loadJoke(handler: @escaping (Result<JokeModel, Error>) -> Void)
}
