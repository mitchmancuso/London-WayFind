//
//  Route.swift
//  London WayFind
//
//  Created by Cara Rosevear on 2019-03-26.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit


class Route {
    
    //MARK: Properties
    
    var name: String
    var number: String
    var url: String
    var fav: Bool
    var saved: Bool
    
    //MARK: Initialization
    
    init?(name: String, number: String, url: String) {
        
        if name.isEmpty ||  number.isEmpty  {
            return nil
        }
        
        self.name = name
        self.number = number
        self.url = url
        self.fav = false
        self.saved = false
        
    }
    
}
