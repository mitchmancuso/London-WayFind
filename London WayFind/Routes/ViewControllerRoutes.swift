//
//  ViewControllerRoutes.swift
//  London WayFind
//
//  Created by Cara Rosevear on 2019-03-27.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit
import WebKit

class ViewControllerRoutes: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //baseLabel.text = routes[newIndex].name
        
        
        
        let url: URL! = URL(string: currentURL )
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    
    override func loadView() {
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
