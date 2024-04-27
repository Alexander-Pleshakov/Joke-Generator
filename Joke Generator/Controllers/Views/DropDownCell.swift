//
//  CategoryCell.swift
//  Joke Generator
//
//  Created by Александр Плешаков on 27.04.2024.
//

import UIKit
import DropDown

class CategoryCell: DropDownCell {
    
    @IBOutlet weak var checkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkImageView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
