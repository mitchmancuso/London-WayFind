//
//  RateMyRideVC.swift
//  London WayFind
//
//  Created by Mitchell Mancuso on 2019-03-28.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit
import AVFoundation

class RateMyRideVC: UIViewController {
    @IBOutlet weak var RateMyRideBacksplash: UIView!
    @IBOutlet weak var QRCodeContentsName: UILabel!
    @IBOutlet weak var QRCodeContentsID: UILabel!
    
    @IBOutlet weak var starOne: UIButton!
    @IBOutlet weak var starTwo: UIButton!
    @IBOutlet weak var starThree: UIButton!
    @IBOutlet weak var starFour: UIButton!
    @IBOutlet weak var starFive: UIButton!
    
    @IBOutlet weak var rateMyRideText: UILabel!
    @IBOutlet weak var submitMyRating: UIButton!
    @IBOutlet weak var submitMyRatingGrey: UIImageView!
    
    @IBOutlet weak var MenuBack: UIView!
    
    var scannedBusName = "[Scan To Fill The Bus Name]"
    var scannedBusID  = "[Scan To Fill the Bus ID]"
    
    var numberOfStars = 0
    
    let ratingSubmittedNotice = UIImageView(image:UIImage(named: "Rating Submitted")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RateMyRideBacksplash.layer.cornerRadius = 10
        MenuBack.layer.cornerRadius = 10
        ratingSubmittedNotice.isHidden = true
        ratingSubmittedNotice.frame = CGRect(x: 68, y: 140, width: 279, height: 44)
        submitMyRating.isHidden = true
        
        QRCodeContentsName.text = scannedBusName
        QRCodeContentsID.text = scannedBusID
        
        if(scannedBusName == "[Scan To Fill The Bus Name]"){
            QRCodeContentsName.textColor = UIColor.gray
            QRCodeContentsID.textColor = UIColor.gray
        }

        let unfilledStar = UIImage(named: "Unfilled Star")
        let filledStar = UIImage(named: "Filled Star")

        starOne.setBackgroundImage(unfilledStar, for: UIControl.State.normal)
        starOne.setBackgroundImage(filledStar, for: UIControl.State.selected)
        
        starTwo.setBackgroundImage(unfilledStar, for: UIControl.State.normal)
        starTwo.setBackgroundImage(filledStar, for: UIControl.State.selected)
        
        starThree.setBackgroundImage(unfilledStar, for: UIControl.State.normal)
        starThree.setBackgroundImage(filledStar, for: UIControl.State.selected)
        
        starFour.setBackgroundImage(unfilledStar, for: UIControl.State.normal)
        starFour.setBackgroundImage(filledStar, for: UIControl.State.selected)
        
        starFive.setBackgroundImage(unfilledStar, for: UIControl.State.normal)
        starFive.setBackgroundImage(filledStar, for: UIControl.State.selected)
        
        view.addSubview(ratingSubmittedNotice)
    }
    
    //Determines if the Star One has been tapped
   @IBAction func starOneTapped(){
        numberOfStars = 1
        if starOne.isSelected {
            starOne.isSelected = true
            starTwo.isSelected = false
            starThree.isSelected = false
            starFour.isSelected = false
            starFive.isSelected = false
        }
        else {
            starOne.isSelected = true
            starTwo.isSelected = false
            starThree.isSelected = false
            starFour.isSelected = false
            starFive.isSelected = false
        }
        toggleSubmit()
    }
    
    //Determines if the Star Two has been tapped
    @IBAction func starTwoTapped(){
        numberOfStars = 2
        if starTwo.isSelected {
            starOne.isSelected = true
            starTwo.isSelected = true
            starThree.isSelected = false
            starFour.isSelected = false
            starFive.isSelected = false
        }
        else {
            starOne.isSelected = true
            starTwo.isSelected = true
            starThree.isSelected = false
            starFour.isSelected = false
            starFive.isSelected = false
        }
         toggleSubmit()
    }
    
    //Determines if the Star Three has been tapped
    @IBAction func starThreeTapped(){
        numberOfStars = 3
        if starThree.isSelected {
            starOne.isSelected = true
            starTwo.isSelected = true
            starThree.isSelected = true
            starFour.isSelected = false
            starFive.isSelected = false
        }
        else {
            starOne.isSelected = true
            starTwo.isSelected = true
            starThree.isSelected = true
            starFour.isSelected = false
            starFive.isSelected = false
        }
         toggleSubmit()
    }
    
    //Determines if the Star Four has been tapped
    @IBAction func starFourTapped(){
        numberOfStars = 4
        if starFour.isSelected {
            starOne.isSelected = true
            starTwo.isSelected = true
            starThree.isSelected = true
            starFour.isSelected = true
            starFive.isSelected = false
        }
        else {
            starOne.isSelected = true
            starTwo.isSelected = true
            starThree.isSelected = true
            starFour.isSelected = true
            starFive.isSelected = false
        }
         toggleSubmit()
    }
    
    //Determines if the Star Five has been tapped
    @IBAction func starFiveTapped(){
        numberOfStars = 5
        if starFive.isSelected {
            starOne.isSelected = true
            starTwo.isSelected = true
            starThree.isSelected = true
            starFour.isSelected = true
            starFive.isSelected = true
        }
        else {
            starOne.isSelected = true
            starTwo.isSelected = true
            starThree.isSelected = true
            starFour.isSelected = true
            starFive.isSelected = true
        }
        toggleSubmit()
    }
    
    //Resets the star rating upon the user clicking to clear
    @IBAction func resetRating(){
            numberOfStars = 0
            starOne.isSelected = false
            starTwo.isSelected = false
            starThree.isSelected = false
            starFour.isSelected = false
            starFive.isSelected = false
            toggleSubmit()
    }
    
    @IBAction func submitRating() {
        print(numberOfStars)
        ratingSubmittedNotice.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        self.backToMain()
        }
    }

    func toggleSubmit() {
        if(scannedBusName != "[Scan To Fill The Bus Name]" && scannedBusID != "[Scan To Fill the Bus ID]" && numberOfStars != 0) {
            submitMyRatingGrey.isHidden = true
            submitMyRating.isHidden = false
        }
        else {
            submitMyRatingGrey.isHidden = false
            submitMyRating.isHidden = true
        }
    }
    
    func backToMain() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainMapViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(mainMapViewController, animated: false, completion: nil)
    }
}
