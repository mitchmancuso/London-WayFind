//
//  MainNavigation.swift
//  London WayFind
//
//  Created by Mitchell Mancuso on 2019-03-28.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit

class MainNavigation: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor.clear
    }
}

