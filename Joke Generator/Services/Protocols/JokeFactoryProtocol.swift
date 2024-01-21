//
//  JokeFactoryProtocol.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 21.01.2024.
//

import Foundation

protocol JokeFactoryProtocol {
    var joke: JokeModel { get }
    func loadJoke()
}
