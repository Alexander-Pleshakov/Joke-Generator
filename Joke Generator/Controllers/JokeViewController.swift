//
//  ViewController.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 18.01.2024.
//

import UIKit

class JokeViewController: UIViewController, JokeFactoryDelegateProtocol {
    // MARK: Properties
    
    private var jokes: JokeModelMock = JokeModelMock()
    private var alertPresenter: AlertPresenter?
    private var joke: JokeModel!
    private var jokeFactory: JokeFactoryProtocol?
    private var jokesLoader: JokesLoaderProtocol = JokesLoader(networkClient: NetworkClient())
    
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
        
        joke = jokes.getJoke()
        
        //showPunchlineOrNextJokeButton.semanticContentAttribute = .forceRightToLeft
        show(model: joke)
    }
    
    //MARK: JokeFactory delegate
    
    func didLoadDataFromServer() {
        <#code#>
    }
    
    func didFailToLoadData(with error: Error) {
        <#code#>
    }
    
    // MARK: Private functions
    
    private func show(model joke: JokeModel) {
        categoryLabel.text = "Category: \(joke.type)"
        setupLabel.text = joke.setup
    }
    
    private func showPunchline(model joke: JokeModel) {
        var model = AlertModel(title: "Punchline", message: joke.punchline, buttonTitle: "Ok") { _ in
            
        }
        alertPresenter?.show(model: model)
    }
    
    private func doActionAndChangeText(button: UIButton) {
        if button.titleLabel?.text == "Show Punchline" {
            button.setTitle("Next joke  ", for: .normal)
            //button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            
            showPunchline(model: joke)
        } else {
            joke = jokes.getJoke()
            show(model: joke)
            
            //button.setImage(UIImage(), for: .normal)
            button.setTitle("Show Punchline", for: .normal)
            
        }
    }
    
    // MARK: Actions
    
    @IBAction func buttonShowPunchlineOrNextJokeDidTap(_ sender: UIButton) {
        doActionAndChangeText(button: sender)
    }
    

}

