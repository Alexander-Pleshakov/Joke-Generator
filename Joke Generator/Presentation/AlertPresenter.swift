//
//  AlertPresenter.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 20.01.2024.
//

import UIKit

final class AlertPresenter {
    let delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func show(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonTitle, style: .default, handler: model.action)
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
