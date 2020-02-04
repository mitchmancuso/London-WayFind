//
//  ARCLViewController.swift
//  ARKit+CoreLocation
//
//  Created by Andrew Hart on 02/07/2017.
//  Copyright © 2017 Project Dent. All rights reserved.
//

import UIKit
import SceneKit
import MapKit
import ARCL

@available(iOS 11.0, *)
class ARCLViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var ExitAR: UIButton!
    @IBOutlet weak var YourBusTextLabel: UILabel!
    @IBOutlet weak var BoxTop: UIView!
    @IBOutlet weak var BoxBody: UIView!
    @IBOutlet weak var YourBusImage: UIImageView!
    @IBOutlet weak var RouteNameText: UILabel!
    @IBOutlet weak var RouteNumberText: UILabel!
    @IBOutlet weak var TimeRemainingText: UILabel!
    @IBOutlet weak var BusSheetDivider: UIImageView!
    @IBOutlet weak var InLabel: UILabel!
    @IBOutlet weak var MinutesLabel: UILabel!
    
    
    @IBOutlet var contentView: UIView!
    let sceneLocationView = SceneLocationView()

    var userAnnotation: MKPointAnnotation?
    var locationEstimateAnnotation: MKPointAnnotation?

    var updateUserLocationTimer: Timer?
    var updateInfoLabelTimer: Timer?

    var centerMapOnUserLocation: Bool = true
    var routes: [MKRoute]?

    var showMap = false {
        didSet {
            guard let mapView = mapView else {
                return
            }
            mapView.isHidden = !showMap
        }
    }

    let displayDebugging = false

    let adjustNorthByTappingSidesOfScreen = false

    class func loadFromStoryboard() -> ARCLViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ARCLViewController") as! ARCLViewController
        // swiftlint:disable:previous force_cast
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        BoxTop.layer.cornerRadius = 10
        BoxBody.layer.cornerRadius = 10
    

        // Now add the route or location annotations as appropriate
        addSceneModels()

        contentView.addSubview(sceneLocationView)
        sceneLocationView.addSubview(ExitAR)
        sceneLocationView.addSubview(BoxTop)
        sceneLocationView.addSubview(BoxBody)
        sceneLocationView.addSubview(YourBusTextLabel)
        sceneLocationView.addSubview(BusSheetDivider)
        sceneLocationView.addSubview(InLabel)
        sceneLocationView.addSubview(TimeRemainingText)
        sceneLocationView.addSubview(MinutesLabel)
        sceneLocationView.addSubview(YourBusImage)
        sceneLocationView.addSubview(RouteNameText)
        sceneLocationView.addSubview(RouteNumberText)
        
        sceneLocationView.frame = contentView.bounds

        mapView.isHidden = !showMap

        if showMap {
            updateUserLocationTimer = Timer.scheduledTimer(
                timeInterval: 0.5,
                target: self,
                selector: #selector(ARCLViewController.updateUserLocation),
                userInfo: nil,
                repeats: true)

            //routes?.forEach { mapView.addOverlay($0.polyline) }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        print("run")
        sceneLocationView.run()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print("pause")
        // Pause the view's session
        sceneLocationView.pause()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = contentView.bounds
    }
}

@available(iOS 11.0, *)
extension ARCLViewController {
    func addSceneModels() {
        guard sceneLocationView.sceneLocationManager.currentLocation != nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.addSceneModels()
            }
            return
        }

        // 2. If there is a route, show that
        if let routes = routes {
            sceneLocationView.addRoutes(routes: routes)
        } else {
            // 3. If not, then show the
            buildARData().forEach {
                sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: $0)
            }
        }
    }

    func buildARData() -> [LocationAnnotationNode] {
        var nodes: [LocationAnnotationNode] = []
        
        let busNode = buildNode(latitude: 42.98719, longitude: -81.156276, altitude: 300, imageName: "AR Mode Box (Demo)")
        nodes.append(busNode)
        RouteNameText.text = "Argyle Mall To Trafalgar Heights"
        RouteNumberText.text = "35"
        TimeRemainingText.text = "5"
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            self.timer()
        }

        return nodes
    }

    @objc func updateUserLocation() {
        guard let currentLocation = sceneLocationView.sceneLocationManager.currentLocation else {
            return
        }

        DispatchQueue.main.async { [weak self ] in
            guard let self = self else {
                return
            }

            if self.userAnnotation == nil {
                self.userAnnotation = MKPointAnnotation()
                self.mapView.addAnnotation(self.userAnnotation!)
            }

            UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
                self.userAnnotation?.coordinate = currentLocation.coordinate
            }, completion: nil)

            if self.centerMapOnUserLocation {
                UIView.animate(withDuration: 0.45,
                               delay: 0,
                               options: .allowUserInteraction,
                               animations: {
                                self.mapView.setCenter(self.userAnnotation!.coordinate, animated: false)
                }, completion: { _ in
                    self.mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
                })
            }

            if self.displayDebugging {
                if let bestLocationEstimate = self.sceneLocationView.sceneLocationManager.bestLocationEstimate {
                    if self.locationEstimateAnnotation == nil {
                        self.locationEstimateAnnotation = MKPointAnnotation()
                        self.mapView.addAnnotation(self.locationEstimateAnnotation!)
                    }
                    self.locationEstimateAnnotation?.coordinate = bestLocationEstimate.location.coordinate
                } else if self.locationEstimateAnnotation != nil {
                    self.mapView.removeAnnotation(self.locationEstimateAnnotation!)
                    self.locationEstimateAnnotation = nil
                }
            }
        }
    }

    func buildNode(latitude: CLLocationDegrees, longitude: CLLocationDegrees,
                   altitude: CLLocationDistance, imageName: String) -> LocationAnnotationNode {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude)
        let image = UIImage(named: imageName)!
        return LocationAnnotationNode(location: location, image: image)
    }

    func buildViewNode(latitude: CLLocationDegrees, longitude: CLLocationDegrees,
                       altitude: CLLocationDistance, text: String) -> LocationAnnotationNode {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.text = text
        label.backgroundColor = .green
        label.textAlignment = .center
        return LocationAnnotationNode(location: location, view: label)
    }
    
    @IBAction func exitARMode() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(homeViewController, animated: false, completion: nil)
    }
    
    func timer() {
        let asInt:Int = Int(TimeRemainingText.text!)!
           TimeRemainingText.text = String(asInt - 1)
    }
}

// MARK: - Helpers

extension DispatchQueue {
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping () -> Void) {
        self.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: execute)
    }
}

extension UIView {
    func recursiveSubviews() -> [UIView] {
        var recursiveSubviews = self.subviews

        subviews.forEach { recursiveSubviews.append(contentsOf: $0.recursiveSubviews()) }

        return recursiveSubviews
    }
}
