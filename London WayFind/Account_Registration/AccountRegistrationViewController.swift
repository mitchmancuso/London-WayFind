//
//  AccountRegistrationViewController.swift
//  London WayFind
//
//  Created by Mitchell Mancuso on 2019-03-28.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit
import Firebase

class AccountRegistrationViewController: UIViewController {
   
    @IBOutlet weak var ContinueToMainScreenButton: UIButton!
    
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var WelcomeLabel: UILabel!
    @IBOutlet weak var ProfilePic: UILabel!
    
    
  let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Adds shadows and rounded corners to the fields
        firstname.layer.cornerRadius = 10
        firstname.layer.shadowColor = UIColor.gray.cgColor
        firstname.layer.shadowOpacity = 0.2
        firstname.layer.shadowOffset = CGSize(width: 0, height: 5)
        firstname.layer.shadowRadius = 5
        firstname.borderStyle = UITextField.BorderStyle.roundedRect
        
        //Adds shadows and rounded corners to the fields
        lastname.layer.cornerRadius = 10
        lastname.layer.shadowColor = UIColor.gray.cgColor
        lastname.layer.shadowOpacity = 0.2
        lastname.layer.shadowOffset = CGSize(width: 0, height: 5)
        lastname.layer.shadowRadius = 5
        lastname.borderStyle = UITextField.BorderStyle.roundedRect
        
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
        
        //Adds shadows and rounded corners to the fields
        passwordConfirm.layer.cornerRadius = 10
        passwordConfirm.layer.shadowColor = UIColor.gray.cgColor
        passwordConfirm.layer.shadowOpacity = 0.2
        passwordConfirm.layer.shadowOffset = CGSize(width: 0, height: 5)
        passwordConfirm.layer.shadowRadius = 5
        passwordConfirm.borderStyle = UITextField.BorderStyle.roundedRect
        
        ContinueToMainScreenButton.layer.cornerRadius = 10
        
        WelcomeLabel.text = "Nice To Meet You!"
        ProfilePic.text = "yes"
        
        let endEditingText = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        endEditingText.cancelsTouchesInView = false
        self.view.addGestureRecognizer(endEditingText)

    }

    @IBAction func signupAction(_ sender: Any) {
        if password.text != passwordConfirm.text {
            let alertController = UIAlertController(title: "Passwords do not match!", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
                if error == nil {
                
                    let userData = ["first-name": self.firstname.text,
                                    "last-name": self.lastname.text, "email-address": self.email.text, "profile-picture-default": self.ProfilePic.text]
                    self.ref.child("users").child(user!.user.uid).setValue(userData)
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
