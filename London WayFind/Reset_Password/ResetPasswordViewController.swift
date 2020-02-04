//
//  ResetPasswordViewController.swift
//  London WayFind
//
//  Created by Mitchell Mancuso on 2019-03-28.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var ResetPasswordTitle: UILabel!
    @IBOutlet weak var ResetPasswordLine1: UILabel!
    @IBOutlet weak var ResetPasswordLine2: UILabel!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var ResetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        //Adds shadows and rounded corners to the fields
        Email.layer.cornerRadius = 10
        Email.layer.shadowColor = UIColor.gray.cgColor
        Email.layer.shadowOpacity = 0.2
        Email.layer.shadowOffset = CGSize(width: 0, height: 5)
        Email.layer.shadowRadius = 5
        Email.borderStyle = UITextField.BorderStyle.roundedRect
        
        ResetPasswordButton.layer.cornerRadius = 10
        
        let endEditingText = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        endEditingText.cancelsTouchesInView = false
        self.view.addGestureRecognizer(endEditingText)

    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
            Auth.auth().sendPasswordReset(withEmail: Email.text!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: error?.localizedDescription, preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.Email.text = ""
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 110
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
