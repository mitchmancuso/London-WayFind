//
//  ReportAnIssueVC.swift
//  London WayFind
//
//  Created by Garren McCallum on 2019-03-24.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit

class ReportAnIssueVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var nameBox: UITextField!
    @IBOutlet weak var messageBox: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var MenuButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuButton.layer.cornerRadius = 10
    }
    
    @IBAction func makeAPhoneCall()  {
        let url: NSURL = URL(string: "TEL://5194511347")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
}
