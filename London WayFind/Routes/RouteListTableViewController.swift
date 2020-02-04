//
//  RouteListTableViewController.swift
//  London WayFind
//
//  Created by Cara Rosevear on 2019-03-26.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit
import WebKit
import Firebase

var routes = [Route]()
var favs = [Route]()
var filteredData = [Route]()
var savedData = [Route]()

var currentURL = String()

var newIndex = 0
var created = false


class RouteListTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var tableViewer: UITableView!
    
    let FavouriteItemsReference = Database.database().reference(withPath: "favourites")
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredData = [Route]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Routes"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        loadSomeRoutes()
        
        let menuImage = UIImage(named: "Navigation Menu (White)")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(openMenu))
        navigationItem.leftBarButtonItem!.tintColor = UIColor.white
        
        FavouriteItemsReference.observe(.value, with:
            {snapshot in
            print(snapshot)
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredData.count
        }
        
        return routes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let starFull = UIImage(named: "Favourite (Filled)")
        let starEmpty = UIImage(named: "Favourite (Unfilled)")
        
        let fileFull = UIImage(named: "Bus Booklet (Filled)")
        let fileEmpty = UIImage(named: "Bus Booklet (Unfilled)")
        
        let route: Route
        
        if isFiltering() {
            route = filteredData[indexPath.row]
        } else {
            route = routes[indexPath.row]
        }
        
        let cellIdentifier = "RouteListTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath ) as? RouteListTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RouteListTableViewCell.")
        }
        
        cell.nameLabel.text = route.name
        cell.nameRoute.text = route.number
        
        cell.favButton.addTarget(self, action: #selector(handleFav), for: .touchUpInside)
        cell.favButton.tag = indexPath.row
        
        cell.saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        
        if ( route.fav == true ) { // Set star to full if a favourite
            
            cell.favButton.setImage(starFull, for: UIControl.State.normal) //When creating the table, check if the route is a favourite so the star is full
            
        } else { // Empty otherwise
            
            cell.favButton.setImage(starEmpty, for: UIControl.State.normal)
            
        }
        
        if ( route.saved == true ) { // Set star to full if a favourite
            
            cell.saveButton.setImage(fileFull, for: UIControl.State.normal) //When creating the table, check if the route is a favourite so the star is full
            
        } else { // Empty otherwise
            
            cell.saveButton.setImage(fileEmpty, for: UIControl.State.normal)
            
        }
        
        return cell
        
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filteredData = routes.filter(
            {
                (route : Route) -> Bool in
                return (route.name.lowercased().contains(searchText.lowercased()) || route.number.lowercased().contains(searchText.lowercased()) )
            }
        )
        
        tableView.reloadData()
    }
    
    
    @objc func handleFav(sender: UIButton) {
        
        let starFull = UIImage(named: "Favourite (Filled)")
        let starEmpty = UIImage(named: "Favourite (Unfilled)")
        
        if isFiltering() {
            
            if(filteredData[sender.tag].fav == false) {
                
                favs += [filteredData[sender.tag]]
                filteredData[sender.tag].fav = true
                sender.setImage(starFull, for: UIControl.State.normal)
                
            } else {
                
                favs = favs.filter(){ ($0).name != (filteredData[sender.tag].name) }
                filteredData[sender.tag].fav = false
                sender.setImage(starEmpty, for: UIControl.State.normal)
                
            }
            
        } else {
            if(routes[sender.tag].fav == false) {
                let favNameRef = self.FavouriteItemsReference.child("currentUser")
                let values =  ["number": routes[sender.tag].number.lowercased()]
                favNameRef.setValue(values)
                
                favs += [routes[sender.tag]]
                routes[sender.tag].fav = true
                sender.setImage(starFull, for: UIControl.State.normal)
                
            } else {
                
                favs = favs.filter(){ ($0).name != (routes[sender.tag].name) }
                routes[sender.tag].fav = false
                sender.setImage(starEmpty, for: UIControl.State.normal)
                
            }
        }
        
        
    }
    
    @objc func handleSave(sender: UIButton) {
        
        
        
        let fileFull = UIImage(named: "Bus Booklet (Filled)")
        let fileEmpty = UIImage(named: "Bus Booklet (Unfilled)")
        
        if isFiltering() {
            
            if(filteredData[sender.tag].saved == false) {
                
                savedData += [filteredData[sender.tag]]
                filteredData[sender.tag].saved = true
                sender.setImage(fileFull, for: UIControl.State.normal)
                
            } else {
                
                savedData = savedData.filter(){ ($0).name != (filteredData[sender.tag].name) }
                filteredData[sender.tag].saved = false
                sender.setImage(fileEmpty, for: UIControl.State.normal)
                
            }
            
        } else {
            if(routes[sender.tag].saved == false) {
                
                savedData += [routes[sender.tag]]
                routes[sender.tag].saved = true
                sender.setImage(fileFull, for: UIControl.State.normal)
                
            } else {
                
                savedData = savedData.filter(){ ($0).name != (routes[sender.tag].name) }
                routes[sender.tag].saved = false
                sender.setImage(fileEmpty, for: UIControl.State.normal)
                
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFiltering() {
            
            currentURL = filteredData[indexPath.row].url
            
        } else {
            
            currentURL = routes[indexPath.row].url
            
        }
        
        if (currentURL == "http://www.londontransit.ca/wp-content/uploads/2018/04/Route-1-2018-September.pdf" && routes[0].saved == true) {
            
            performSegue(withIdentifier: "downloadsegue1", sender: self)
            
        } else if ( currentURL == "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-4-2018-September-Rev-2.pdf" && routes[3].saved == true ) {
            
            performSegue(withIdentifier: "downloadsegue4", sender: self)
            
        } else{
            
            performSegue(withIdentifier: "segue", sender: self)
            
        }
        
    }
    
    private func loadSomeRoutes() {
        
        if(created == false) {
            
            guard let route1 = Route(name: "Kipps Lane - Pond Mills Rd / King Edward", number: "1", url : "http://www.londontransit.ca/wp-content/uploads/2018/04/Route-1-2018-September.pdf") else {
                fatalError("Unable to instantiate route1")
            }
            
            guard let route2 = Route(name: "Natural Science - Trafalgar Heights/Bonaventure", number: "2", url: "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-2-2018-September-Rev-4.pdf") else {
                fatalError("Unable to instantiate route2")
            }
            
            guard let route3 = Route(name: "Downtown - Fairmont/Argyle Mall", number: "3", url: "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-3-5-2018-September-Rev3.pdf") else {
                fatalError("Unable to instantiate route3")
            }
            
            guard let route4 = Route(name: "Fanshawe College - White Oaks Mall", number: "4", url: "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-4-2018-September-Rev-2.pdf") else {
                fatalError("Unable to instantiate route4")
            }
            
            guard let route5 = Route(name: "Byron - Downtown", number: "5", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-3-5-2019-Winter-1.pdf") else {
                fatalError("Unable to instantiate route5")
            }
            
            guard let route6 = Route(name: "Natural Science - Parkwood Institute", number: "6", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-6-2018-September.pdf") else {
                fatalError("Unable to instantiate route6")
            }
            
            guard let route7 = Route(name: "Downtown - Argyle Mall", number: "7", url: "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-7-11-September_Rev2.pdf") else {
                fatalError("Unable to instantiate route7")
            }
            
            guard let route9 = Route(name: "Downtown - Whitehills", number: "9", url: "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-9-2018-September_Rev2.pdf") else {
                fatalError("Unable to instantiate route9")
            }
            
            guard let route10 = Route(name: "Natural Science - White Oaks Mall", number: "10", url: "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-10-14-2018-September_Rev3Fixed-Satina.pdf") else {
                fatalError("Unable to instantiate route10")
            }
            
            guard let route11 = Route(name: "Downtown - Westmount Mall", number: "11", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-7-11-September_Rev3.pdf") else {
                fatalError("Unable to instantiate route11")
            }
            
            guard let route12 = Route(name: "Downtown - Wharncliffe and Wonderland", number: "12", url: "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-12-2018-September_Rev1.pdf") else {
                fatalError("Unable to instantiate route12")
            }
            
            guard let route13 = Route(name: "White Oaks Mall - Masonville Place", number: "13", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-13-2018-September.pdf") else {
                fatalError("Unable to instantiate route13")
            }
            
            guard let route14 = Route(name: "White Oaks Mall - Barker and Huron", number: "14", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-10-14-2018-September_Rev2Fixed-10-Sunday.pdf") else {
                fatalError("Unable to instantiate route14")
            }
            
            guard let route15 = Route(name: "Downtown to Westmount Mall", number: "15", url: "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-15-21-2018-September_Rev1-1.pdf") else {
                fatalError("Unable to instantiate route15")
            }
            
            guard let route16 = Route(name: "Masonville Mall - Pond Mills/Summerside", number: "16", url: "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-16-2018-September_Rev1.pdf") else {
                fatalError("Unable to instantiate route16")
            }
            
            guard let route17 = Route(name: "Argyle Mall - Byron/Riverbend", number: "17", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-17-2018-November.pdf:") else {
                fatalError("Unable to instantiate route17")
            }
            
            guard let route19 = Route(name: "Downtown - Hyde Park Power Centre", number: "19", url: "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-19-31-32-2018-September_Rev3.pdf") else {
                fatalError("Unable to instantiate route19")
            }
            
            guard let route20 = Route(name: "Fanshawe College - Beaverbrook", number: "20", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-20-2018-December-Change.pdf") else {
                fatalError("Unable to instantiate route20")
            }
            
            guard let route21 = Route(name: "Downtown to Huron Heights", number: "21", url: "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-15-21-2018-September_Rev1-1.pdf") else {
                fatalError("Unable to instantiate route21")
            }
            
            guard let route24 = Route(name: "Talbot Village - Victoria Hospital", number: "24", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-24-2019-February-2.pdf") else {
                fatalError("Unable to instantiate route24")
            }
            
            guard let route25 = Route(name: "Fanshawe College - Masonville Place", number: "25", url : "http://www.londontransit.ca/wp-content/uploads/2018/04/Route-25-2018-Spring.pdf") else {
                fatalError("Unable to instantiate route25")
            }
            
            guard let route26 = Route(name: "Downtown - White Oaks Mall", number: "26", url : "http://www.londontransit.ca/wp-content/uploads/2018/11/Route-26-2018-November.pdf") else {
                fatalError("Unable to instantiate route26")
            }
            
            guard let route27 = Route(name: "Fanshawe College - Kipps Lane", number: "27", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-27-2018-September.pdf") else {
                fatalError("Unable to instantiate route27")
            }
            
            guard let route28 = Route(name: "Westmount Mall - Capulet", number: "28", url : "http://www.londontransit.ca/wp-content/uploads/2017/11/Route-28-2017-Web-November.pdf") else {
                fatalError("Unable to instantiate route28")
            }
            
            guard let route29 = Route(name: "Natural Science - Capulet", number: "29", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-29-2018-September_Rev1.pdf") else {
                fatalError("Unable to instantiate route29")
            }
            
            guard let route30 = Route(name: "White Oaks Mall - Cheese Factory Rd", number: "30", url : "http://www.londontransit.ca/wp-content/uploads/2017/11/30ltc.pdf") else {
                fatalError("Unable to instantiate route30")
            }
            
            guard let route31 = Route(name: "Hyde Park Power Centre - Alumni Hall", number: "31", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-19-31-32-2018-September_Rev3.pdf") else {
                fatalError("Unable to instantiate route31")
            }
            
            guard let route32 = Route(name: "Alumni Hall - Huron and Highbury", number: "32", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-19-31-32-2018-September_Rev3.pdf") else {
                fatalError("Unable to instantiate route32")
            }
            
            guard let route33 = Route(name: "Alumni Hall - Farrah and Proudfoot", number: "33", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-33-2018-September-Rev1.pdf") else {
                fatalError("Unable to instantiate route33")
            }
            
            guard let route34 = Route(name: "Alumni Hall - Masonville Place", number: "34", url : "http://www.londontransit.ca/wp-content/uploads/2018/04/Route-34-2018-Spring.pdf") else {
                fatalError("Unable to instantiate route34")
            }
            
            guard let route35 = Route(name: "Argyle Mall to Trafalgar Heights", number: "35", url : "http://www.londontransit.ca/wp-content/uploads/2017/11/Route-35-2017-Web-November.pdf") else {
                fatalError("Unable to instantiate route35")
            }
            
            guard let route36 = Route(name: "Fanshawe College to London Airport", number: "36", url : "http://www.londontransit.ca/wp-content/uploads/2017/11/Route-36-2018-November.pdf") else {
                fatalError("Unable to instantiate route36")
            }
            
            guard let route37 = Route(name: "Argyle Mall to Neptune Crescent", number: "37", url : "http://www.londontransit.ca/wp-content/uploads/2017/11/Route-37-2017-Web-November.pdf") else {
                fatalError("Unable to instantiate route37")
            }
            
            guard let route38 = Route(name: "Masonville Mall - Stoney Creek", number: "38", url : "http://www.londontransit.ca/wp-content/uploads/2018/11/Route-38-39-2018-Nov-Rev-1.pdf") else {
                fatalError("Unable to instantiate route38")
            }
            
            guard let route39 = Route(name: "Masonville Mall - Hyde Park Power Centre", number: "39", url : "http://www.londontransit.ca/wp-content/uploads/2018/11/Route-38-39-2018-Nov-Rev-1.pdf") else {
                fatalError("Unable to instantiate route39")
            }
            
            guard let route40 = Route(name: "Masonville Place to Northridge", number: "40", url : "http://www.londontransit.ca/wp-content/uploads/2018/04/Route-40-2018-Spring.pdf") else {
                fatalError("Unable to instantiate route40")
            }
            
            guard let route51 = Route(name: "Community Bus (Monday)", number: "51", url : "http://www.londontransit.ca/wp-content/uploads/2018/04/Route-51-Apr.pdf") else {
                fatalError("Unable to instantiate route51")
            }
            
            guard let route52 = Route(name: "Community Bus (Tuesday)", number: "52", url : "http://www.londontransit.ca/route/route-52-community-bus-tuesday/") else {
                fatalError("Unable to instantiate route52")
            }
            
            guard let route53 = Route(name: "Community Bus (Wednesday)", number: "53", url : "http://www.londontransit.ca/route/route-53-community-bus-wednesday/") else {
                fatalError("Unable to instantiate route53")
            }
            
            guard let route54 = Route(name: "Community Bus (Thursday)", number: "54", url : "http://www.londontransit.ca/route/route-54-community-bus-thursday/") else {
                fatalError("Unable to instantiate route54")
            }
            
            guard let route55 = Route(name: "Community Bus (Friday)", number: "55", url : "http://www.londontransit.ca/route/route-55/") else {
                fatalError("Unable to instantiate route55")
            }
            
            guard let route90 = Route(name: "Express – Masonville Place to White Oaks Mall", number: "90", url : "http://www.londontransit.ca/wp-content/uploads/2018/11/Route-90-2018-November-Rev1.pdf") else {
                fatalError("Unable to instantiate route90")
            }
            
            guard let route91 = Route(name: "Express – Fanshawe to Oxford & Wonderland", number: "91", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-91-2018-September.pdf") else {
                fatalError("Unable to instantiate route91")
            }
            
            guard let route92 = Route(name: "Express Masonville to Victoria Hospital", number: "92", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-92-2018-September.pdf") else {
                fatalError("Unable to instantiate route92")
            }
            
            guard let route102 = Route(name: "Downtown to Natural Science", number: "102", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-102-106-2018-September_Rev1.pdf") else {
                fatalError("Unable to instantiate route102")
            }
            
            guard let route106 = Route(name: "Downtown to Natural Science", number: "106", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-102-106-2018-September_Rev1.pdf") else {
                fatalError("Unable to instantiate route102")
            }
            
            guard let route104 = Route(name: "Ridout & Grand to Fanshawe College", number: "104", url : "http://www.londontransit.ca/wp-content/uploads/2018/08/Route-104-2018-September-Rev2.pdf") else {
                fatalError("Unable to instantiate route104")
            }
            
            routes += [route1, route2, route3, route4, route5, route6, route7, route9, route10, route11, route12, route13, route14, route15,
                       route16, route17, route19, route20, route21, route24, route25, route26, route27, route28, route29, route30, route31, route32,
                       route33, route34, route35, route36, route37, route38, route39, route40, route51, route52, route53, route54, route55, route90, route91, route92, route102, route106, route104]
            
            created = true
            
        }
    }

    @objc func openMenu() {
        self.navigationController?.navigationBar.isHidden = true
        let storyBoard: UIStoryboard = UIStoryboard(name: "Routes", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "NavigationViewControllerRoutes") as! MainNavigationFromRoutesViewController
        self.present(mainViewController, animated: false, completion: nil)
    }

}

extension RouteListTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

