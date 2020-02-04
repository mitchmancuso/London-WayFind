//
//  RoundedButtonView.swift
//  London WayFind
//
//  Created by Garren McCallum on 2019-03-24.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit

class RoundedButtonView: UIView {
    
    override func awakeFromNib() {
        setupView()
    }

    func setupView(){
        self.layer.cornerRadius = 5.0
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor(red: 0.27, green: 0.36, blue: 0.39, alpha: 0.08).cgColor
        self.layer.shadowRadius = 16
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}
