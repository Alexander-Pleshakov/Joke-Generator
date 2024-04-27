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
    
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["Item1", "Item2", "Item3"]
        menu.cellNib = UINib(nibName: "DropDownCell", bundle: nil)
        
        return menu
    }()
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var showPunchlineOrNextJokeButton: UIButton!
    @IBOutlet private weak var setupLabel: UILabel!
    @IBOutlet weak var titleJokeLabel: UILabel!
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropDownMenuConfigure()
        
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
    
    private func dropDownMenuConfigure() {
        menu.anchorView = categoryButton
        menu.direction = .bottom
        menu.bottomOffset = CGPoint(x: 0, y:(menu.anchorView?.plainView.bounds.height)!)
        DropDown.appearance().cornerRadius = 10
        
        menu.customCellConfiguration = { index, title, cell in
            guard let cell = cell as? CategoryCell else {
                return
            }
            cell.checkImageView.image = UIImage(systemName: "checkmark")
        }
        
        menu.selectionAction = { [weak self] (index, title) in
            guard let self = self else { return }
            print("Button with index \(index) and title - \(title) was tapped")
            // jokesLoader?.updateCategories()
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

