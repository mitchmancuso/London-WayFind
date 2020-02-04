//
//  MainNavigationFromFavouritesViewController.swift
//  London WayFind
//
//  Created by Mitchell Mancuso on 2019-03-28.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit
import Firebase

class MainNavigationFromFavouritesViewController: UIViewController {
    //Blue Panel
    @IBOutlet weak var MainNavigationPanel: UIView!
    
    //UserProfileImage
    @IBOutlet weak var UserProfileImage: UIImageView!
    
    //UserName & Email Labels
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var UserEmailLabel: UILabel!
    
    //Menu Buttons
    @IBOutlet weak var HomeButton: UIButton!
    @IBOutlet weak var FavouritesButton: UIButton!
    @IBOutlet weak var RoutesButton: UIButton!
    @IBOutlet weak var LostAndFoundButton: UIButton!
    @IBOutlet weak var ReportAnIssueButton: UIButton!
    @IBOutlet weak var RateMyRideButton: UIButton!
    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var SettingsButton: UIButton!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gives the navigation panel rounded edges and a slight shadow
        MainNavigationPanel.layer.cornerRadius = 20
        MainNavigationPanel.layer.shadowColor = UIColor.gray.cgColor
        MainNavigationPanel.layer.shadowOpacity = 0.2
        MainNavigationPanel.layer.shadowRadius = 5
        
        //Allows for the view controller to be transparent
        view.isOpaque = false
        view.backgroundColor = .clear
        
        //Round Edges Profile Image
        UserProfileImage.layer.masksToBounds = false
        UserProfileImage.layer.cornerRadius = 20
        UserProfileImage.clipsToBounds = true
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            let value = snapshot.value as! [String: AnyObject]
            let firstName = value["first-name"] as! String
            let email = value["email-address"] as! String
            self.UserNameLabel.text = firstName
            self.UserEmailLabel.text = email
            
        }) { (error) in
            print(error.localizedDescription)
        }
        

    }
    
    //Transitions to the Home view scene when the Home button is tapped
    @IBAction func homeView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(mainViewController, animated: false, completion: nil)
    }
    
    //Transitions to the Favourites view scene when the Favourites button is tapped
    @IBAction func favouritesView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Routes", bundle: nil)
        let favouritesViewController = storyBoard.instantiateViewController(withIdentifier: "FavouritesEntryViewController") as! UINavigationController
        self.present(favouritesViewController, animated: false, completion: nil)
    }
    
    //Transitions to the Routes view scene when the Routes button is tapped
    @IBAction func routesView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Routes", bundle: nil)
        let routesViewController = storyBoard.instantiateViewController(withIdentifier: "RoutesEntryViewController") as! UINavigationController
        self.present(routesViewController, animated: false, completion: nil)
    }
    
    //Transitions to the Lost And Found view scene when the Lost And Found button is tapped
    @IBAction func lostAndFoundView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Secondary_Screens", bundle: nil)
        let lostAndFoundViewController = storyBoard.instantiateViewController(withIdentifier: "LostAndFoundViewController") as! LostAndFoundVC
        self.present(lostAndFoundViewController, animated: false, completion: nil)
    }
    
    //Transitions to the Report An Issue view scene when the Report An Issue button is tapped
    @IBAction func reportAnIssueView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Secondary_Screens", bundle: nil)
        let reportAnIssueViewController = storyBoard.instantiateViewController(withIdentifier: "ReportAnIssueViewController") as! ReportAnIssueVC
        self.present(reportAnIssueViewController, animated: false, completion: nil)
    }
    
    //Transitions to the Rate My Ride view scene when the Rate My Ride button is tapped
    @IBAction func rateMyRideview(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Secondary_Screens", bundle: nil)
        let rateMyRideViewController = storyBoard.instantiateViewController(withIdentifier: "RateMyRideViewController") as! RateMyRideVC
        self.present(rateMyRideViewController, animated: false, completion: nil)
    }
    
    //Transitions to the Splash Screen view scene when the Log Out button is tapped
    @IBAction func splashScreenview(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "User_Authentication", bundle: nil)
        let splashScreenViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeScreenViewController") as! WelcomeScreenViewController
        self.present(splashScreenViewController, animated: false, completion: nil)
    }
    
    //Transitions to the Settings view scene when the Settings button is tapped
    @IBAction func settingsScreenview(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Secondary_Screens", bundle: nil)
        let settingsScreenViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsVC
        self.present(settingsScreenViewController, animated: false, completion: nil)
    }
    
}


