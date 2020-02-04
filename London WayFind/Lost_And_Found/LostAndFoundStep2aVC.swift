//
//  LostAndFoundVC.swift
//  London WayFind
//
//  Created by Garren McCallum on 2019-03-24.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit

class LostAndFoundStep2aVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var TakeAnImageButton: UIButton!
    @IBOutlet weak var MenuBack: UIView!
    @IBOutlet weak var Step2aBackground: UIView!
    @IBOutlet weak var ItemDescription: UITextField!
    @IBOutlet weak var CheckBox: UIButton!
    @IBOutlet weak var RouteFoundOn: UITextField!
    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var RetakeImage: UIButton!
    
    @IBOutlet weak var InformationView: UIButton!
    @IBOutlet weak var FoundInformation: UIImageView!
    
    @IBOutlet weak var SubmitAvailable: UIButton!
    @IBOutlet weak var SubmitGreyed: UIImageView!
    
    @IBOutlet weak var ReportSubmitted: UIImageView!
    
    var ItemDescriptionText = ""
    var RouteFoundOnText = ""
    var checkBoxSelected = 0
    
    var imagePicker: UIImagePickerController!
    
    
    let routePicker = UIPickerView()
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
        RouteFoundOn.text = routePickerData[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FoundInformation.isHidden = true
        ItemImage.isHidden = true
        ItemImage.layer.cornerRadius = 10
        SubmitAvailable.isHidden = true
        RetakeImage.isHidden = true
        ReportSubmitted.isHidden = true
        
        MenuBack.layer.cornerRadius = 10
        Step2aBackground.layer.cornerRadius = 10
        ItemDescription.borderStyle = UITextField.BorderStyle.roundedRect
        RouteFoundOn.borderStyle = UITextField.BorderStyle.roundedRect
        
        CheckBox.setBackgroundImage(UIImage(named: "Unchecked Box"), for: UIControl.State.normal)
        CheckBox.setBackgroundImage(UIImage(named: "Checked Box"), for: UIControl.State.selected)
        
        routePicker.delegate = self
        
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
        
        RouteFoundOn.inputView = routePicker
        RouteFoundOn.inputAccessoryView = toolBar

    }
    
    @IBAction func checkboxSelected() {
        CheckBox.isSelected.toggle()
        if(checkBoxSelected == 0) {
        checkBoxSelected = 1
        checkRequirements()
        }
        else {
            checkBoxSelected = 0
            checkRequirements()
        }
    }
    
    @IBAction func descriptionReturned(_ sender: UITextField) {
        ItemDescriptionText = ItemDescription.text!
        checkRequirements()
        //print(ItemDescriptionText)
        sender.resignFirstResponder()
    }

    @objc func donePicker() {
        descriptionReturned(ItemDescription)
        RouteFoundOnText = RouteFoundOn.text!
        routePicker.selectRow(0, inComponent: 0, animated: false)
        //print(RouteFoundOnText)
        checkRequirements()
        RouteFoundOn.resignFirstResponder()
    }
    
    @objc func cancelPicker() {
        descriptionReturned(ItemDescription)
        RouteFoundOnText = ""
        RouteFoundOn.text = ""
        routePicker.selectRow(0, inComponent: 0, animated: false)
        //print(RouteFoundOnText)
        checkRequirements()
        RouteFoundOn.resignFirstResponder()
    }
    
    func checkRequirements() {
        if (ItemDescriptionText != "" && RouteFoundOnText != "" && checkBoxSelected != 0) {
            SubmitGreyed.isHidden = true
            SubmitAvailable.isHidden = false
        }
        else {
            SubmitGreyed.isHidden = false
            SubmitAvailable.isHidden = true
        }
    }
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        TakeAnImageButton.isHidden = true
        ItemImage.isHidden = false
        RetakeImage.isHidden = false
        ItemImage.image = info[.originalImage] as? UIImage
    }
    
    @IBAction func backToMain() {
        ReportSubmitted.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainMapViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(mainMapViewController, animated: false, completion: nil)
        }
    }
    @IBAction func informationView() {
        InformationView.isSelected.toggle()
        FoundInformation.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            self.FoundInformation.isHidden = true
        }
    }
}
