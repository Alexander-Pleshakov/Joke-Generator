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
    
    var menu: CategoriesMenu!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var showPunchlineOrNextJokeButton: UIButton!
    @IBOutlet private weak var setupLabel: UILabel!
    @IBOutlet weak var titleJokeLabel: UILabel!
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu = CategoriesMenu(delegate: self)
        
        activityIndicator.hidesWhenStopped = true
        
        jokesLoader = JokesLoader(networkClient: NetworkClient())
        jokeFactory = JokeFactory(delegate: self, jokesLoader: jokesLoader)
        alertPresenter = AlertPresenter(delegate: self)
        
        activityIndicator.startAnimating()
        jokeFactory.loadJoke()
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
        setupLabel.text = ""
    }
    
    private func show(model joke: JokeModel?) {
        guard let joke = joke else {
            print("joke == nil")
            return
        }
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
    
    @IBAction func buttonCategoryTapped(_ sender: Any) {
        menu.show()
    }
    
}

extension JokeViewController {
    func getAnchorView() -> UIView {
        return categoryButton
    }
    
    func setDownImageForButton() {
        categoryButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
    }
    
    func setUpImageForButton() {
        categoryButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
    }
    
    func updateCategoryButton(title: String, count: Int) {
        if count == 1 {
            categoryButton.setTitle(title, for: .normal)
        } else {
            categoryButton.setTitle("Many categories", for: .normal)
        }
        
        if count == 0 {
            categoryButton.setTitle("No category", for: .normal)
        }
    }
}

