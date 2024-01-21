//
//  ViewController.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 18.01.2024.
//

import UIKit

class JokeViewController: UIViewController, JokeFactoryDelegateProtocol {
    // MARK: Properties
    
    private var alertPresenter: AlertPresenter?
    private var jokeFactory: JokeFactoryProtocol!
    private var jokesLoader: JokesLoaderProtocol = JokesLoader(networkClient: NetworkClient())
    private var currentJoke: JokeModel?
    
    // MARK: Outlets
    
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var showPunchlineOrNextJokeButton: UIButton!
    @IBOutlet private weak var setupLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jokesLoader = JokesLoader(networkClient: NetworkClient())
        jokeFactory = JokeFactory(delegate: self, jokesLoader: jokesLoader)
        alertPresenter = AlertPresenter(delegate: self)
        
        jokeFactory.loadJoke()
        
        //show(model: currentJoke)
    }
    
    //MARK: JokeFactory delegate
    
    func didReceiveNextJoke(joke: JokeModel?) {
        guard let joke = joke else {
            return
        }
        currentJoke = joke
//        DispatchQueue.main.async { [weak self] in
//            self?.show(model: self?.currentJoke)
//        }
        show(model: currentJoke)
    }
    
    func didLoadDataFromServer() {
        jokeFactory.requestJoke()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: Private functions
    
    private func show(model joke: JokeModel?) {
        guard let joke = joke else {
            print("joke == nil")
            return
        }
        categoryLabel.text = "Category: \(joke.type)"
        setupLabel.text = joke.setup
    }
    
    private func showPunchline(model joke: JokeModel?) {
        guard let joke = joke else { return }
        var model = AlertModel(title: "Punchline", message: joke.punchline, buttonTitle: "Ok") { _ in
            
        }
        alertPresenter?.show(model: model)
    }
    
    private func showNetworkError(message: String) {
        let alertModel = AlertModel(title: "Ошибка загрузки", message: message, buttonTitle: "Попробовать еще раз") { [weak self] _ in
            guard let self = self else { return }
            jokeFactory.loadJoke()
        }
        alertPresenter?.show(model: alertModel)
    }
    
    private func doActionAndChangeText(button: UIButton) {
        if button.titleLabel?.text == "Show Punchline" {
            button.setTitle("Next joke  ", for: .normal)
            
            showPunchline(model: currentJoke)
        } else {
            jokeFactory.loadJoke()
            show(model: currentJoke)
            
            button.setTitle("Show Punchline", for: .normal)
            
        }
    }
    
    // MARK: Actions
    
    @IBAction func buttonShowPunchlineOrNextJokeDidTap(_ sender: UIButton) {
        doActionAndChangeText(button: sender)
    }
    

}

