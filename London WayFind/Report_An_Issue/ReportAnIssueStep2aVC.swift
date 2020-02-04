//
//  ReportAnIssueStep2aVC.swift
//  London WayFind
//
//  Created by Garren McCallum on 2019-04-05.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit

class ReportAnIssueStep2aVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var nameBox: UITextField!
    @IBOutlet weak var routeBox: UITextField!
    @IBOutlet weak var messageBox: UITextView!
    
    @IBOutlet weak var SubmitTicket: UIButton!
    @IBOutlet weak var SubmitTicketGrey: UIImageView!
    @IBOutlet weak var TicketDisclaimer: UIImageView!
    @IBOutlet weak var TicketSubmitted: UIImageView!
    
    @IBOutlet weak var MenuButton: UIView!
    @IBOutlet weak var MainBox: UIView!
    @IBOutlet weak var InformationButton: UIButton!
    
    let picker = UIPickerView()
    var currentTxtFldTag : Int = 10
    
    var timer : Timer?
    
    var RouteText = ""
    var TypeOfIssueText = ""
    var MainMessageText = ""
    
    
    let routePickerData = [String](arrayLiteral: "1 - Kipps Lane", "2 - Natural Science - Trafalgar", "3 - Downtown - Fairmont", "4 - Fanshawe College - White Oaks", "5 - Byron - Downtown", "6 - Natural Science - Parkwood", "7 - Downtown - Argyle Mall", "9 - Downtown - Whitehills", "10 - Natural Science - White Oaks", "11 - Downtown - Westmount","12 - Downtown - Wharncliffe", "13 - White Oaks Mall - Masonville", "14 - White Oaks Mall - Barker", "15 - Downtown to Westmount", "16 - Masonville Mall - Pond Mills", "17 - Argyle Mall - Byron", "19 - Downtown - Hyde Park", "20 - Fanshawe College - Beaverbrook", "21 - Downtown to Huron Heights", "24 - Talbot Village - Victoria", "25 - Fanshawe College - Masonville", "26 - Downtown - White Oaks", "27 - Fanshawe College - Kipps", "28 - Westmount Mall - Capulet", "29 - Natural Science - Capulet", "30 - White Oaks Mall - Cheese Factory", "31 - Hyde Park Power Centre - Alumni", "32 - Alumni Hall - Huron", "33 - Alumni Hall - Farrah", "34 - Alumni Hall - Masonville", "35 - Argyle Mall to Trafalgar", "36 - Fanshawe College to London Airport", "37 - Argyle Mall to Neptune", "38 - Masonville Mall - Stoney Creek", "39 - Masonville Mall - Hyde Park", "40 - Masonville Place to Northridge", "51 - Community Bus (Monday)", "52 - Community Bus (Tuesday)", "53 - Community Bus (Wednesday)", "54 - Community Bus (Thursday)", "55 - Community Bus (Friday)", "90 - Express – Masonville to White Oaks", "91 - Express – Fanshawe to Oxford & Wonderland", "92 - Express Masonville to Victoria", "102 - Downtown to Natural Science", "104 - Ridout & Grand to Fanshawe College")
    
    let issuePickerData = [String](arrayLiteral: "Bus Maintenance / Facilities", "Driver Conduct", "Fare Pricing","Rider Conduct", "Other")
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTxtFldTag == 10
        {
            return issuePickerData.count
        }
        else
        {
            return routePickerData.count
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTxtFldTag == 10
        {
            return issuePickerData[row]
        }
        else
        {
            return routePickerData[row]
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTxtFldTag == 10
        {
            nameBox.text = issuePickerData[row]
        }
        else
        {
            routeBox.text = routePickerData[row]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: Selector(("setData")), userInfo: nil, repeats: true)
        
        SubmitTicket.isHidden = true
        SubmitTicketGrey.isHidden = false
        TicketDisclaimer.isHidden = true
        TicketSubmitted.isHidden = true

        nameBox.layer.cornerRadius = 10
        MenuButton.layer.cornerRadius = 10
        MainBox.layer.cornerRadius = 10
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        picker.delegate = self
        picker.dataSource = self
        
        nameBox.tag = 10
        routeBox.tag = 20
        
        nameBox.delegate = self
        routeBox.delegate = self
    
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneRoutePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelRoutePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        routeBox.inputView = picker
        routeBox.borderStyle = UITextField.BorderStyle.roundedRect
        routeBox.inputAccessoryView = toolBar
        
        let toolBarIssue = UIToolbar()
        toolBarIssue.barStyle = UIBarStyle.default
        toolBarIssue.isTranslucent = true
        toolBarIssue.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        toolBarIssue.sizeToFit()
        
        let doneButtonIssue = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneIssuePicker))
        let spaceButtonIssue = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButtonIssue = UIBarButtonItem(title: "Clear", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelIssuePicker))
        
        toolBarIssue.setItems([cancelButtonIssue, spaceButtonIssue, doneButtonIssue], animated: false)
        toolBarIssue.isUserInteractionEnabled = true
    
        nameBox.inputView = picker
        nameBox.inputAccessoryView = toolBarIssue
        
        // Set the shadows of the name box
        nameBox.borderStyle = UITextField.BorderStyle.roundedRect
        nameBox.layer.masksToBounds = false
        nameBox.layer.cornerRadius = 5.0;
        nameBox.layer.backgroundColor = UIColor.white.cgColor
        nameBox.layer.borderColor = UIColor.clear.cgColor
        nameBox.layer.shadowColor = UIColor.black.cgColor
        nameBox.layer.shadowOffset = CGSize(width: 0, height: 4)
        nameBox.layer.shadowOpacity = 0.2
        nameBox.layer.shadowRadius = 4.0
        
        let toolBarDesc = UIToolbar()
        toolBarDesc.barStyle = UIBarStyle.default
        toolBarDesc.isTranslucent = true
        toolBarDesc.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        toolBarDesc.sizeToFit()
        
        let doneButtonDesc = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneDesc))
        let spaceButtonDesc = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButtonDesc = UIBarButtonItem(title: "Clear", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelDesc))
        
        toolBarDesc.setItems([cancelButtonDesc, spaceButtonDesc, doneButtonDesc], animated: false)
        toolBarDesc.isUserInteractionEnabled = true
        messageBox.inputAccessoryView = toolBarDesc
    
        
        let endSearchTap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        endSearchTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(endSearchTap)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func doneRoutePicker() {
        picker.selectRow(0, inComponent: 0, animated: false)
        checkRequirements()
        routeBox.resignFirstResponder()
    }
    
    @objc func cancelRoutePicker() {
        RouteText = ""
        routeBox.text = ""
        picker.selectRow(0, inComponent: 0, animated: false)
        routeBox.resignFirstResponder()
    }
    
    @objc func doneIssuePicker() {
        picker.selectRow(0, inComponent: 0, animated: false)
        checkRequirements()
        nameBox.resignFirstResponder()
    }
    
    @objc func cancelIssuePicker() {
        TypeOfIssueText = ""
        nameBox.text = ""
        picker.selectRow(0, inComponent: 0, animated: false)
        nameBox.resignFirstResponder()
    }
    
    @objc func doneDesc() {
        checkRequirements()
        messageBox.resignFirstResponder()
    }
    
    @objc func cancelDesc() {
        MainMessageText = ""
        messageBox.text = ""
        messageBox.resignFirstResponder()
    }
    
    func checkRequirements() {
        if( RouteText != "" && TypeOfIssueText != "" && MainMessageText != "") {
            SubmitTicket.isHidden = false
            SubmitTicketGrey.isHidden = true
        }
        else {
            SubmitTicket.isHidden = true
            SubmitTicketGrey.isHidden = false
        }
         // print("------------------------------------------------")
         // print("Issue Category Is: " + TypeOfIssueText)
         // print("Route Is: " + RouteText)
         // print("Main Message Is: " + MainMessageText)
         // print("------------------------------------------------")
    }
    
    @IBAction func informationView() {
        InformationButton.isSelected.toggle()
        TicketDisclaimer.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            self.TicketDisclaimer.isHidden = true
        }
    }
    
    @IBAction func descriptionReturned(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func routeReturned(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func backToMain() {
        TicketDisclaimer.isHidden = true
        TicketSubmitted.isHidden = false
        timer?.invalidate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainMapViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(mainMapViewController, animated: false, completion: nil)
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        MainMessageText = messageBox.text!
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 110
        }
        checkRequirements()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func setData() {
        TypeOfIssueText = nameBox.text!
        RouteText = routeBox.text!
        MainMessageText = messageBox.text!
        checkRequirements()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 10  {
            currentTxtFldTag = 10
        }
        else {
            currentTxtFldTag = 20
        }
        picker.reloadAllComponents()
        return true
    }
    
    @IBAction func destroyTimer() {
        timer?.invalidate()
    }
}
