//
//  AlertModel.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 20.01.2024.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonTitle: String
    let action: ((UIAlertAction) -> Void)?
}
