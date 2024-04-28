//
//  CategoriesMenu.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 28.04.2024.
//

import Foundation
import DropDown

final class CategoriesMenu {
    
    weak var delegate: CategoriesMenuDelegate!
    
    init(delegate: CategoriesMenuDelegate) {
        self.delegate = delegate
        dropDownMenuConfigure()
    }
    
    private let menu: DropDown = {
        let menu = DropDown()
        menu.cellNib = UINib(nibName: "DropDownCell", bundle: nil)
        
        return menu
    }()
    
    private var selectedCategories: Set<String> = ["Any category"]
    private let allCategories = ["Any category", "Programming", "Misc", "Dark", "Pun", "Spooky", "Christmas"]
    
    func show() {
        menu.show()
    }
    
    private func dropDownMenuConfigure() {
        menu.dataSource = allCategories
        
        let color = UIColor(named: "JG White") ?? .white
        
        DropDown.appearance().selectionBackgroundColor = color
        DropDown.appearance().backgroundColor = color
        
        menu.anchorView = delegate.getAnchorView()
        menu.direction = .bottom
        menu.bottomOffset = CGPoint(x: 0, y:(menu.anchorView?.plainView.bounds.height)!)
        DropDown.appearance().cornerRadius = 10
        
        menu.cancelAction = { [weak self] in
            self?.delegate.setDownImageForButton()
        }

        menu.willShowAction = { [weak self] in
            guard let self = self else { return }
            self.delegate.setUpImageForButton()
            
            addCategory()
        }
        
        menu.multiSelectionAction = { [weak self] (index, titles) in
            guard let self = self else { return }
            
            if selectedCategories.contains("Any category") {
                self.selectedCategories = Set(titles)
                self.selectedCategories.remove("Any category")
                let i = allCategories.firstIndex(of: selectedCategories.first!)!
                menu.clearSelection()
                
                menu.selectRow(at: i)
               
                addCategory()
                
                delegate.updateCategoryButton(title: allCategories[i], count: selectedCategories.count)
                
                return
            }
            
            self.selectedCategories = Set(titles)
            
            if selectedCategories.contains("Any category") {
                menu.clearSelection()
                menu.selectRow(0)
                selectAny()
            } else {
                self.selectedCategories = Set(titles)
                delegate.updateCategoryButton(title: selectedCategories.first ?? "", count: selectedCategories.count)
                addCategory()
            }
        }
    }
    
    private func selectAny() {
        menu.customCellConfiguration = { [weak self] index, title, cell in
            guard let cell = cell as? CategoryCell,
                  let self = self
            else { return }
            
            if selectedCategories.contains("Any category"){
                self.selectedCategories = ["Any category"]
                delegate.updateCategoryButton(title: "Any category", count: selectedCategories.count)
            }
            
            if selectedCategories.contains(title) {
                cell.checkImageView.image = UIImage(systemName: "checkmark")
            } else {
                cell.checkImageView.image = UIImage()
            }
        }
    }
    
    private func addCategory() {
        menu.customCellConfiguration = { [weak self] index, title, cell in
            guard let cell = cell as? CategoryCell,
                  let self = self
            else { return }
        
            if selectedCategories.contains(title) {
                cell.checkImageView.image = UIImage(systemName: "checkmark")
            } else {
                cell.checkImageView.image = UIImage()
            }
        }
    }
}
