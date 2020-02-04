//
//  SignInViewController.swift
//  London WayFind
//
//  Created by Mitchell Mancuso on 2019-03-28.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//
import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var WelcomeLabel: UILabel!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var ResetPassword: UIButton!
    
    @IBOutlet weak var SignInToMainScreen: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WelcomeLabel.text = "Welcome Back!"
        
        //Adds shadows and rounded corners to the fields
        email.layer.cornerRadius = 10
        email.layer.shadowColor = UIColor.gray.cgColor
        email.layer.shadowOpacity = 0.2
        email.layer.shadowOffset = CGSize(width: 0, height: 5)
        email.layer.shadowRadius = 5
        email.borderStyle = UITextField.BorderStyle.roundedRect
        
        //Adds shadows and rounded corners to the fields
        password.layer.cornerRadius = 10
        password.layer.shadowColor = UIColor.gray.cgColor
        password.layer.shadowOpacity = 0.2
        password.layer.shadowOffset = CGSize(width: 0, height: 5)
        password.layer.shadowRadius = 5
        password.borderStyle = UITextField.BorderStyle.roundedRect
        
        SignInToMainScreen.layer.cornerRadius = 10

    }
    
    @IBAction func loginAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainMapViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.present(mainMapViewController, animated: false, completion: nil)
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func returned(_ sender: UITextField) {
        sender.resignFirstResponder()
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
