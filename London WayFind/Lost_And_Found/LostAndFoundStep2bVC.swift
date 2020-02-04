//
//  LostAndFoundStep2bVC.swift
//  London WayFind
//
//  Created by Mitchell Mancuso on 2019-04-04.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit

class LostAndFoundStep2bVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var MenuBack: UIView!
    @IBOutlet weak var Step2BBack: UIView!
    
    
    @IBOutlet weak var ReportSubmissionStatement: UIImageView!
    @IBOutlet weak var ItemLost: UITextField!
    @IBOutlet weak var RouteLostOn: UITextField!
    @IBOutlet weak var DateLost: UITextField!
    @IBOutlet weak var OptionalInformation: UITextField!
    
    @IBOutlet weak var InformationButton: UIButton!
    @IBOutlet weak var InformationDisclaimer: UIImageView!
    
    @IBOutlet weak var SubmitReport: UIButton!
    @IBOutlet weak var SubmitNotAvailable: UIImageView!
    
    var timer : Timer?
    
    var ItemDescriptionText = ""
    var RouteLostOnText = ""
    var DateLostOnText = ""
    var OptionalText = ""
    
    var informationActive = 0
    
    let routePicker = UIPickerView()
    let datePicker = UIDatePicker()
    
    let routePickerData = [String](arrayLiteral: "1 - Kipps Lane", "2 - Natural Science - Trafalgar", "3 - Downtown - Fairmont", "4 - Fanshawe College - White Oaks", "5 - Byron - Downtown", "6 - Natural Science - Parkwood", "7 - Downtown - Argyle Mall", "9 - Downtown - Whitehills", "10 - Natural Science - White Oaks", "11 - Downtown - Westmount","12 - Downtown - Wharncliffe", "13 - White Oaks Mall - Masonville", "14 - White Oaks Mall - Barker", "15 - Downtown to Westmount", "16 - Masonville Mall - Pond Mills", "17 - Argyle Mall - Byron", "19 - Downtown - Hyde Park", "20 - Fanshawe College - Beaverbrook", "21 - Downtown to Huron Heights", "24 - Talbot Village - Victoria", "25 - Fanshawe College - Masonville", "26 - Downtown - White Oaks", "27 - Fanshawe College - Kipps", "28 - Westmount Mall - Capulet", "29 - Natural Science - Capulet", "30 - White Oaks Mall - Cheese Factory", "31 - Hyde Park Power Centre - Alumni", "32 - Alumni Hall - Huron", "33 - Alumni Hall - Farrah", "34 - Alumni Hall - Masonville", "35 - Argyle Mall to Trafalgar", "36 - Fanshawe College to London Airport", "37 - Argyle Mall to Neptune", "38 - Masonville Mall - Stoney Creek", "39 - Masonville Mall - Hyde Park", "40 - Masonville Place to Northridge", "51 - Community Bus (Monday)", "52 - Community Bus (Tuesday)", "53 - Community Bus (Wednesday)", "54 - Community Bus (Thursday)", "55 - Community Bus (Friday)", "90 - Express – Masonville to White Oaks", "91 - Express – Fanshawe to Oxford & Wonderland", "92 - Express Masonville to Victoria", "102 - Downtown to Natural Science", "104 - Ridout & Grand to Fanshawe College")
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return routePickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return routePickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        RouteLostOn.text = routePickerData[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: Selector(("setData")), userInfo: nil, repeats: true)
        
        SubmitReport.isHidden = true
        SubmitNotAvailable.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        MenuBack.layer.cornerRadius = 10
        Step2BBack.layer.cornerRadius = 10
        InformationDisclaimer.isHidden = true
        
        ReportSubmissionStatement.isHidden = true
        
        ItemLost.borderStyle = UITextField.BorderStyle.roundedRect
        RouteLostOn.borderStyle = UITextField.BorderStyle.roundedRect
        DateLost.borderStyle = UITextField.BorderStyle.roundedRect
        OptionalInformation.borderStyle = UITextField.BorderStyle.roundedRect
        
        routePicker.delegate = self
        showDatePicker()
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        RouteLostOn.inputView = routePicker
        RouteLostOn.inputAccessoryView = toolBar
        
        //Hides the main search if any other area is tapped
        let endSearchTap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        endSearchTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(endSearchTap)
    }
    
    @objc func donePicker() {
        routePicker.selectRow(0, inComponent: 0, animated: false)
        checkRequirements()
        RouteLostOn.resignFirstResponder()
    }
    
    @objc func cancelPicker() {
        RouteLostOnText = ""
        RouteLostOn.text = ""
        routePicker.selectRow(0, inComponent: 0, animated: false)
        checkRequirements()
        RouteLostOn.resignFirstResponder()
    }
    
    func checkRequirements() {
        if( ItemDescriptionText != "" && RouteLostOnText != "" && DateLostOnText != "") {
            SubmitReport.isHidden = false
            SubmitNotAvailable.isHidden = true
        }
        else {
            SubmitReport.isHidden = true
            SubmitNotAvailable.isHidden = false
        }
       // print("------------------------------------------------")
       // print("Item Description Is: " + ItemDescriptionText)
       // print("Route Lost On Is: " + RouteLostOnText)
       // print("Date Lost On Is: " + DateLostOnText)
       // print("Additional Item Information Is: " + OptionalText)
       // print("------------------------------------------------")
    }
    
    @IBAction func informationView() {
        InformationButton.isSelected.toggle()
        InformationDisclaimer.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                self.InformationDisclaimer.isHidden = true
        }
    }
    
    @IBAction func descriptionReturned(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func dateReturned(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func additionalInformationReturned(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func backToMain() {
        InformationDisclaimer.isHidden = true
        ReportSubmissionStatement.isHidden = false
        timer?.invalidate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainMapViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(mainMapViewController, animated: false, completion: nil)
        }
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        ItemDescriptionText = ItemLost.text!
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
        ItemDescriptionText = ItemLost.text!
        RouteLostOnText = RouteLostOn.text!
        DateLostOnText = DateLost.text!
        OptionalText = OptionalInformation.text!
        checkRequirements()
    }

    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        toolbar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(cancelDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));

        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        DateLost.inputAccessoryView = toolbar
        DateLost.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        DateLostOnText = formatter.string(from: datePicker.date)
        DateLost.text = formatter.string(from: datePicker.date)
        checkRequirements()
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        DateLostOnText = ""
        DateLost.text = ""
        checkRequirements()
        self.view.endEditing(true)
    }
    
    @IBAction func destroyTimer() {
        timer?.invalidate()
    }
}
