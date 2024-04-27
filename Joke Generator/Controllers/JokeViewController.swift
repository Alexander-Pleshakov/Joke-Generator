//
//  ViewController.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 18.01.2024.
//

import UIKit
import DropDown

class JokeViewController: UIViewController, JokeFactoryDelegateProtocol {
    // MARK: Properties
    
    private var alertPresenter: AlertPresenter?
    private var jokeFactory: JokeFactoryProtocol!
    private var jokesLoader: JokesLoaderProtocol = JokesLoader(networkClient: NetworkClient())
    private var currentJoke: JokeModel?
    
    // MARK: Outlets
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var showPunchlineOrNextJokeButton: UIButton!
    @IBOutlet private weak var setupLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        
        jokesLoader = JokesLoader(networkClient: NetworkClient())
        jokeFactory = JokeFactory(delegate: self, jokesLoader: jokesLoader)
        alertPresenter = AlertPresenter(delegate: self)
        
        activityIndicator.startAnimating()
        jokeFactory.loadJoke()
        
        //show(model: currentJoke)
    }
    
    //MARK: JokeFactory delegate
    
    func didReceiveNextJoke(joke: JokeModel?) {
        guard let joke = joke else {
            return
        }
        currentJoke = joke
        show(model: currentJoke)
        activityIndicator.stopAnimating()
    }
    
    func didLoadDataFromServer() {
        jokeFactory.requestJoke()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: Private functions
    
    private func goToNextJoke() {
        activityIndicator.startAnimating()
        categoryLabel.text = ""
        setupLabel.text = ""
    }
    
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
        let model = AlertModel(title: "Punchline", message: joke.punchline, buttonTitle: "Ok") { _ in
            
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
            goToNextJoke()
            jokeFactory.loadJoke()
            
            button.setTitle("Show Punchline", for: .normal)
            
        }
    }
    
    // MARK: Actions
    
    @IBAction func buttonShowPunchlineOrNextJokeDidTap(_ sender: UIButton) {
        doActionAndChangeText(button: sender)
    }
    

}

