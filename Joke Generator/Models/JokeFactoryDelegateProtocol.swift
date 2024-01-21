//
//  JokeFactoryDelegateProtocol.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 21.01.2024.
//

import Foundation

protocol JokeFactoryDelegateProtocol {
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
