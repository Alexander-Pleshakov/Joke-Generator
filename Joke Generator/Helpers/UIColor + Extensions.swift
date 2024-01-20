//
//  UIColor + Extensions.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 18.01.2024.
//

import UIKit

extension UIColor {
    static var backgroundJG: UIColor {
        UIColor(named: "JG Background") ?? UIColor.gray
    }
    
    static var darkPurpleJG: UIColor {
        UIColor(named: "JG DarkPurple") ?? UIColor.purple
    }
    
    static var textColorJG: UIColor {
        UIColor(named: "JG TextColor") ?? UIColor.black
    }
    
    static var whiteJG: UIColor {
        UIColor(named: "JG White") ?? UIColor.black
    }
    
    static var yellowJG: UIColor {
        UIColor(named: "JG Yellow") ?? UIColor.black
    }
}


