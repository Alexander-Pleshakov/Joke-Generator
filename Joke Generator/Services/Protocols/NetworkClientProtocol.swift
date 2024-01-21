//
//  NetworkClientProtocol.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 21.01.2024.
//

import Foundation

protocol NetworkClientProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
