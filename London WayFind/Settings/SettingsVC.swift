//
//  SettingsVC.swift
//  London WayFind
//
//  Created by Garren McCallum on 2019-03-24.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   
    @IBOutlet weak var MenuButton: UIView!
    @IBOutlet weak var SettingsBackgroundBox: UIView!
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var SetNewProfileImage: UIButton!
    @IBOutlet weak var NewFirstName: UITextField!
    @IBOutlet weak var NewLastName: UITextField!
    @IBOutlet weak var NewEmailAddress: UITextField!
    @IBOutlet weak var NewPassword: UITextField!
    @IBOutlet weak var NewVerifiedPassword: UITextField!
    
    
    @IBOutlet weak var CurrentFirstName: UILabel!
    @IBOutlet weak var CurrentLastName: UILabel!
    @IBOutlet weak var CurrentEmail: UILabel!
    
    @IBOutlet weak var SubmitChanges: UIButton!
    @IBOutlet weak var SubmitChangesGrey: UIImageView!
    @IBOutlet weak var SuccessMessage: UIImageView!
    
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var UserLastNameLabel: UILabel!
    @IBOutlet weak var UserEmailLabel: UILabel!
    
    var NewFirstNameText = ""
    var NewLastNameText = ""
    var NewEmailAddressText = ""
    var NewPasswordText = ""
    var NewPasswordVerifyText = ""
    
    var timer : Timer?
    
    var profileImageSet = 0
    
    var ref = Database.database().reference()
    let storage = Storage.storage()
    let userID = Auth.auth().currentUser?.uid
    
    @IBOutlet var newProfilePicture: UIImageView!
    
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuButton.layer.cornerRadius = 10
        SettingsBackgroundBox.layer.cornerRadius = 20
        ProfileImage.layer.cornerRadius = 10
        SubmitChanges.isHidden = true
        SuccessMessage.isHidden = true
    
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            let value = snapshot.value as! [String: AnyObject]
            let firstName = value["first-name"] as! String
            let lastName = value["last-name"] as! String
            let email = value["email-address"] as! String
            self.UserNameLabel.text = firstName
            self.UserLastNameLabel.text = lastName
            self.UserEmailLabel.text = email
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        CurrentFirstName.text = "Current First Name:"
        CurrentLastName.text = "Current Last Name:"
        CurrentEmail.text = "Current E-Mail:"
        
        NewFirstName.borderStyle = UITextField.BorderStyle.roundedRect
        NewLastName.borderStyle = UITextField.BorderStyle.roundedRect
        NewEmailAddress.borderStyle = UITextField.BorderStyle.roundedRect
        NewPassword.borderStyle = UITextField.BorderStyle.roundedRect
        NewVerifiedPassword.borderStyle = UITextField.BorderStyle.roundedRect
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(setData), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let endSearchTap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        endSearchTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(endSearchTap)
        
        print(profileImageSet)
    }
    
    @IBAction func returnFromDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 200
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func checkRequirements() {
        if((NewFirstNameText != "" || NewLastNameText != "" || NewEmailAddressText != "" || profileImageSet == 1) && (NewPasswordText == "" && NewPasswordVerifyText == "") || ((NewPasswordText != "" && NewPasswordVerifyText != "") && (NewPasswordText == NewPasswordVerifyText))) {
            SubmitChanges.isHidden = false
            SubmitChangesGrey.isHidden = true
        }
        else {
            SubmitChanges.isHidden = true
            SubmitChangesGrey.isHidden = false
        }
        // print("------------------------------------------------")
        // print("New First Name Is: " + NewFirstNameText)
        // print("New Last Name Is: " + NewLastNameText)
        // print("New Email Address Is: " + NewEmailAddressText)
        // print("New Password Is: " + NewPasswordText)
        // print("New Password Verification Is: " + NewPasswordVerifyText)
        // print("New Profile Image Set? (0 = N, 1 = Y): " + String(profileImageSet))
        // print("------------------------------------------------")
    }
    
    @objc func setData() {
        NewFirstNameText = NewFirstName.text!
        NewLastNameText = NewLastName.text!
        NewEmailAddressText = NewEmailAddress.text!
        NewPasswordText = NewPassword.text!
        NewPasswordVerifyText = NewVerifiedPassword.text!
        checkRequirements()
    }
    
    @IBAction func destroyTimer() {
        timer?.invalidate()
    }
    
    @IBAction func backToMain() {
        SuccessMessage.isHidden = false
        timer?.invalidate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainMapViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(mainMapViewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    func loadImage() {
        // Data in memory
        let data = Data()
        let storageRef = storage.reference()
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("images/rivers.jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
    }
}

extension SettingsVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.ProfileImage.image = image
        profileImageSet = 1
        loadImage()
    }
}
