//
//  ViewController.swift
//  London WayFind
//
//  Created by Mitchell Mancuso on 2019-03-14.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
// convert string to double for using parse text file in lat, long
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}


protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class ViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var MainSearch: UITextField!
    @IBOutlet weak var SearchAreaBackView: UIView!
    @IBOutlet weak var MainMap: MKMapView!
    @IBOutlet weak var MenuButon: UIButton!
    
    @IBOutlet weak var ExpandButton: UIButton!
    @IBOutlet weak var NearbyRoutesSm: UILabel!
    @IBOutlet weak var MapPinSm: UIImageView!
    @IBOutlet weak var GradientBarSm: UIImageView!
    @IBOutlet weak var MainViewSm: UIView!
    
    @IBOutlet weak var CollapseButton: UIButton!
    @IBOutlet weak var MainViewLg: UIView!
    @IBOutlet weak var NearbyRoute1: UIButton!
    @IBOutlet weak var NearbyRoute2: UIButton!
    @IBOutlet weak var NearbyRoute3: UIButton!
    
    @IBOutlet weak var Route1Header: UILabel!
    @IBOutlet weak var Route2Header: UILabel!
    @IBOutlet weak var Route3Header: UILabel!
    
    @IBOutlet weak var Route1Mins: UILabel!
    @IBOutlet weak var Route2Mins: UILabel!
    @IBOutlet weak var Route3Mins: UILabel!
    
    let currentLocationButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
    let arModeButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
    
    var locationManager: CLLocationManager?
    var previousLocation: CLLocation?
    
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    var points = [CLLocationCoordinate2D]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainViewSm.isHidden = false
        MainViewLg.isHidden = true
    
        //Sets custom features of the map, styling and initial location
        MainMap.delegate = self
        
        //Sets the initial region to be London, Ontario
        defaultRegionMapView()
        
        //Responsible for creating the Location Manager object and setting accuracy requirement
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        // AR Mode Button
        arModeButton.frame = CGRect(x: 340, y: 660, width: 52, height: 52)
        arModeButton.setBackgroundImage(UIImage(named: "AR Mode (Unselected)"), for: UIControl.State.normal)
        arModeButton.setBackgroundImage(UIImage(named: "AR Mode (Selected)"), for: UIControl.State.selected)
        arModeButton.addTarget(self, action: #selector(arModeTapped), for: .touchUpInside)
        arModeButton.layer.shadowColor = UIColor.gray.cgColor
        arModeButton.layer.shadowOpacity = 0.3
        arModeButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        arModeButton.layer.shadowRadius = 3
        arModeButton.isHidden = true
        self.view.addSubview(arModeButton)
        
        
        // Current Location Button
        currentLocationButton.frame = CGRect(x: 340, y: 720, width: 52, height: 52)
        currentLocationButton.setBackgroundImage(UIImage(named: "Current Location (Unselected)"), for: UIControl.State.normal)
        currentLocationButton.setBackgroundImage(UIImage(named: "Current Location (Selected)"), for: UIControl.State.selected)
        currentLocationButton.addTarget(self, action: #selector(currentLocationTapped), for: .touchUpInside)
        currentLocationButton.layer.shadowColor = UIColor.gray.cgColor
        currentLocationButton.layer.shadowOpacity = 0.3
        currentLocationButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        currentLocationButton.layer.shadowRadius = 3
        self.view.addSubview(currentLocationButton)
    
        //Adds shadows and rounded corners to the search bar
        SearchAreaBackView.layer.cornerRadius = 10
        SearchAreaBackView.layer.shadowColor = UIColor.gray.cgColor
        SearchAreaBackView.layer.shadowOpacity = 0.2
        SearchAreaBackView.layer.shadowOffset = CGSize(width: 0, height: 20)
        SearchAreaBackView.layer.shadowRadius = 5
        

        //Hides the main search if any other area is tapped
        MainSearch.delegate = self
        let endSearchTap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        endSearchTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(endSearchTap)

        
        /*
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = MainMap
        locationSearchTable.handleMapSearchDelegate = self
 */
    }
    
    //Determines if the Current Location Button has been tapped
    @objc func currentLocationTapped(){
        if currentLocationButton.isSelected == true {
            currentLocationButton.isSelected = false
            endLocationServices()
            self.MainMap.showsUserLocation = false;
            defaultRegionMapView()
        }
        else {
            currentLocationButton.isSelected = true
            startLocationService()
            self.MainMap.showsUserLocation = true;
            setCurrentLocationMapView()
            
        }
    }
        
    @objc func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
        }
    
    @IBAction func presentModal() {
        let modalController = MainNavigationFromHomeViewController()
        modalController.modalPresentationStyle = .overCurrentContext
        present(modalController, animated: true, completion: nil)
    }
    
    //Determines if the AR Mode Button has been tapped
    @objc func arModeTapped(){
        arModeButton.isSelected.toggle()
        arModeView()
    }

    //Transitions to the AR Mode view scene when the AR Mode button is tapped
    @objc func arModeView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "AR_Mode", bundle: nil)
        let arViewController = storyBoard.instantiateViewController(withIdentifier: "ARCLViewController") as! ARCLViewController
        self.present(arViewController, animated: false, completion: nil)
    }

    //Responsible for starting the location services chain and checking authorization
    func startLocationService(){
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //activateLocationServices()
    }
        else {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    //If the user has activated Location Services, start updating the location
    private func activateLocationServices(){
        locationManager?.startUpdatingLocation()
    }
    
    //Otherwise, if the user toggles the button, then stop updating the location
    private func endLocationServices(){
        locationManager?.stopUpdatingLocation()
    }
    
    @IBAction func HideSmallMenu() {
        MainViewSm.isHidden = true
        MainViewLg.isHidden = false
        currentLocationButton.frame = CGRect(x: 340, y: 560, width: 52, height: 52)
        NearbyRoute1.layer.cornerRadius = 10
        NearbyRoute2.layer.cornerRadius = 10
        NearbyRoute3.layer.cornerRadius = 10
        
        Route1Header.text = "Route 6"
        Route2Header.text = "Route 2"
        Route3Header.text = "Route 16"
        
        Route1Mins.text = "5 Mins"
        Route2Mins.text = "7 Mins"
        Route3Mins.text = "7 Mins"
        
        currentLocationTapped()
    }
    
    @IBAction func HideLargeMenu() {
        MainViewSm.isHidden = false
        MainViewLg.isHidden = true
        arModeButton.isHidden = true
        currentLocationButton.frame = CGRect(x: 340, y: 720, width: 52, height: 52)
        currentLocationTapped()
    }
    
    @IBAction func showRoute1Map() {
        arModeButton.isHidden = true
        arModeButton.isHidden = false
        arModeButton.frame = CGRect(x: 340, y: 500, width: 52, height: 52)
        //Adds the annotations and line on map
        buildMapStops()
    }
    
    //Hides the search if any type of return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Resets to an overhead view of London Ontario
    func defaultRegionMapView(){
        let defaultRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.9849, longitude: -81.2453), latitudinalMeters: 10000, longitudinalMeters: 10000)
        MainMap.setRegion (defaultRegion, animated: true)
        MainMap.showsCompass = false
    }
 
    
    //Sets to the user's current location
    func setCurrentLocationMapView(){
        if let userLocation = locationManager?.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            MainMap.setRegion(viewRegion, animated: true)
        }
        MainMap.showsCompass = false
    }
    
    func buildMapStops() {
        MainMap.removeAnnotations(MainMap.annotations)
        if let filepath = Bundle.main.path(forResource: "redux_route_data", ofType: "txt") {
            if let contents = try? String(contentsOfFile: filepath) {
                let lines = contents.components(separatedBy: "\n")
                for line in lines {
                    if (line.isEmpty) {
                        break
                    }
                    if (line.contains("stop_id")) {
                        continue
                    }
                    
                    let elements = line.components (separatedBy: ",")
                    // print element 5 lat,
                    //print(elements[4])
                    
                    let lat = elements[4]
                    let long = elements[5]
                    let latstring = lat
                    let myDoublelat = latstring.toDouble()
                    let longstring = long
                    let myDoublelong = longstring.toDouble()
                    
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: myDoublelat ?? 0.0, longitude: myDoublelong ?? 0.0)
                    annotation.title = "Stop " + elements[0]
                    points.append(annotation.coordinate)
                    
                    MainMap.addAnnotation(annotation)
                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
                    MainMap.setRegion(region, animated: true)
                }
            }
        }
        let routeLine = MKPolyline(coordinates: points, count: points.count)
        MainMap.addOverlay(routeLine)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin shift blue"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.image = UIImage(named: "pin shift blue")
            pinView?.annotation = annotation
        }
        pinView?.image = UIImage(named: "pin shift blue")
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "Your Bus"), for: .normal)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let testlineRenderer = MKPolylineRenderer(polyline: polyline)
            testlineRenderer.strokeColor = .blue
            testlineRenderer.lineWidth = 3.0
            return testlineRenderer
        }
        fatalError("Fatal Error...")
        //return MKOverlayRenderer()
    }
    
 
}

/*
//An extension of the ViewController to acocunt for the MKMapViewDelegate
//Primarily, this is used for setting the custom overlay
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
 */


//Stores all the functions related to finding the user's current location and authorization status
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse || status == .authorizedAlways {
          //  activateLocationServices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        if previousLocation == nil {
            previousLocation = locations.first
        }
        else {
            guard let latest = locations.first else {return}
            previousLocation = latest
        }
 
        guard let location = locations.first else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        MainMap.setRegion(region, animated: true)
    }
}


extension ViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        MainMap.removeAnnotations(MainMap.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let province = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(province)"
        }
        
        MainMap.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        MainMap.setRegion(region, animated: true)
    }
}

    /* Original
     func buildMapStops() {
     MainMap.removeAnnotations(MainMap.annotations)
     if let filepath = Bundle.main.path(forResource: "routes", ofType: "txt") {
     do {
     let contents = try String(contentsOfFile: filepath)
     print(contents)
     } catch {
     // contents could not be loaded
     }
     } else {
     // example.txt not found!
     }
     let annotation = MKPointAnnotation()
     annotation.coordinate = CLLocationCoordinate2D(latitude: 42.974289, longitude: -81.225234)
     annotation.title = "Test Stop"
     
     MainMap.addAnnotation(annotation)
     let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
     let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
     MainMap.setRegion(region, animated: true)
     
     }
     */

