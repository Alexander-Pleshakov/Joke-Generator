//
//  CategoriesMenuDelegate.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 28.04.2024.
//

import UIKit

protocol CategoriesMenuDelegate: AnyObject {
    func getAnchorView() -> UIView
    
    func setDownImageForButton()
    
    func setUpImageForButton()
    
    func updateCategoryButton(title: String, count: Int)
}
