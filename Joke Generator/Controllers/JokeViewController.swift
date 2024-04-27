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
    
    var selectedCategories: Set<String> = ["Any category"]
    let allCategoriesSet: Set<String> = ["Any category", "Programming", "Misc", "Dark", "Pun", "Spooky", "Christmas"]
    let allCategories = ["Any category", "Programming", "Misc", "Dark", "Pun", "Spooky", "Christmas"]
    
    // MARK: Outlets
    
    let menu: DropDown = {
        let menu = DropDown()
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
        menu.dataSource = allCategories
        
        menu.anchorView = categoryButton
        menu.direction = .bottom
        menu.bottomOffset = CGPoint(x: 0, y:(menu.anchorView?.plainView.bounds.height)!)
        DropDown.appearance().cornerRadius = 10
        
        menu.selectionAction = { [weak self] (index, title) in
            guard let self = self else { return }
            
            if self.selectedCategories.contains(title) {
                deleteImageFromMenu(for: title)
            } else {
                if title == "Any category" {
                    setMenuImagesForAnyCategory()
                    return
                }
                setImageForMenu(for: title)
            }
        }
        
        menu.cancelAction = { [weak self] in
            self?.categoryButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }

        menu.willShowAction = { [weak self] in
            guard let self = self else { return }
            self.categoryButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            let array = Array(selectedCategories)
            for category in array{
                setImageForMenu(for: category)
            }
        }
    }
    
    private func updateCategoryButton(title: String) {
        if self.selectedCategories.count == 1 {
            categoryButton.setTitle(title, for: .normal)
        } else {
            categoryButton.setTitle("Many categories", for: .normal)
        }
        
        if self.selectedCategories.count == 0 {
            categoryButton.setTitle("No category", for: .normal)
        }
    }
    
    private func setMenuImagesForAnyCategory() {
        menu.customCellConfiguration = { [weak self] index, title, cell in
            guard let cell = cell as? CategoryCell,
                  let self = self
            else { return }
            
            if title == "Any category" {
                self.selectedCategories = ["Any category"]
                updateCategoryButton(title: title)
            }
            
            if selectedCategories.contains(title) {
                cell.checkImageView.image = UIImage(systemName: "checkmark")
            } else {
                cell.checkImageView.image = UIImage()
            }
        }
    }
    
    private func deleteImageFromMenu(for str: String) {
        menu.customCellConfiguration = { [weak self] index, title, cell in
            guard let cell = cell as? CategoryCell,
                  let self = self
            else { return }
            
            if str == title {
                self.selectedCategories.remove(title)
                updateCategoryButton(title: title)
                return
            }
            
            if selectedCategories.contains(title) {
                cell.checkImageView.image = UIImage(systemName: "checkmark")
            } else {
                cell.checkImageView.image = UIImage()
            }
        }
    }
    
    private func setImageForMenu(for str: String) {
        menu.customCellConfiguration = { [weak self] index, title, cell in
            guard let cell = cell as? CategoryCell,
                  let self = self
            else { return }
            
            if str == title {
                self.selectedCategories.insert(title)
                updateCategoryButton(title: title)
            }
            
            if self.selectedCategories.contains("Any category") && self.selectedCategories.count != 1 {
                self.selectedCategories.remove("Any category")
            }
            
            if selectedCategories.contains(title) {
                cell.checkImageView.image = UIImage(systemName: "checkmark")
            } else {
                cell.checkImageView.image = UIImage()
            }
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

