//
//  FavListTableViewController.swift
//  London WayFind
//
//  Created by Cara Rosevear on 2019-03-28.
//  Copyright © 2019 CS4474BG7. All rights reserved.
//

import UIKit
import WebKit

var newURL = ""

class FavListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tblview: UITableView!
    let searchControllerFavs = UISearchController(searchResultsController: nil)
    var filteredDataFavs = [Route]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchControllerFavs.searchResultsUpdater = self
        searchControllerFavs.obscuresBackgroundDuringPresentation = false
        searchControllerFavs.searchBar.placeholder = "Search Favourites"
        
        navigationItem.searchController = searchControllerFavs
        definesPresentationContext = true
        
        let menuImage = UIImage(named: "Navigation Menu (White)")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(openMenu))
        navigationItem.leftBarButtonItem!.tintColor = UIColor.white
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredDataFavs.count
        }
        
        return favs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let fileFull = UIImage(named: "Bus Booklet (Filled)")
        let fileEmpty = UIImage(named: "Bus Booklet (Unfilled)")
        
        let cellIdentifier = "RouteListTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath ) as? RouteListTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RouteListTableViewCell.")
        }
        
        let route: Route
        
        if isFiltering() {
            route = filteredDataFavs[indexPath.row]
        } else {
            route = favs[indexPath.row]
        }
        
        cell.nameLabel.text = route.name
        cell.nameRoute.text = route.number
        
        cell.favButton.addTarget(self, action: #selector(handleFav), for: .touchUpInside)
        cell.favButton.tag = indexPath.row
        
        cell.saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        
        if ( route.saved == true ) { // Set star to full if a favourite
            
            cell.saveButton.setImage(fileFull, for: UIControl.State.normal) //When creating the table, check if the route is a favourite so the star is full
            
        } else { // Empty otherwise
            
            cell.saveButton.setImage(fileEmpty, for: UIControl.State.normal)
            
        }
        
        return cell
        
    }
    
    
    @objc func handleFav(sender: UIButton) {
        
        
        if isFiltering() {
            
            filteredDataFavs[sender.tag].fav = false
            favs = favs.filter(){ ($0).name != (filteredDataFavs[sender.tag].name) }
            filteredDataFavs = filteredDataFavs.filter(){ ($0).name != (filteredDataFavs[sender.tag].name) }
            
        } else {
            
            favs[sender.tag].fav = false
            favs = favs.filter(){ ($0).name != (favs[sender.tag].name) }
            
        }
        
        
        tblview.reloadData()
    }
    
    @objc func handleSave(sender: UIButton) {
        
        let fileFull = UIImage(named: "Bus Booklet (Filled)")
        let fileEmpty = UIImage(named: "Bus Booklet (Unfilled)")
        
        if isFiltering() {
            
            if(filteredData[sender.tag].saved == false) {
                
                savedData += [filteredDataFavs[sender.tag]]
                filteredDataFavs[sender.tag].saved = true
                sender.setImage(fileFull, for: UIControl.State.normal)
                
            } else {
                
                savedData = savedData.filter(){ ($0).name != (filteredDataFavs[sender.tag].name) }
                filteredDataFavs[sender.tag].saved = false
                sender.setImage(fileEmpty, for: UIControl.State.normal)
                
            }
            
        } else {
            if(favs[sender.tag].saved == false) {
                
                savedData += [favs[sender.tag]]
                favs[sender.tag].saved = true
                sender.setImage(fileFull, for: UIControl.State.normal)
                
            } else {
                
                savedData = savedData.filter(){ ($0).name != (favs[sender.tag].name) }
                favs[sender.tag].saved = false
                sender.setImage(fileEmpty, for: UIControl.State.normal)
                
            }
        }
        
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchControllerFavs.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchControllerFavs.isActive && !searchBarIsEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filteredDataFavs = favs.filter(
            {
                (route : Route) -> Bool in
                return (route.name.lowercased().contains(searchText.lowercased()) || route.number.lowercased().contains(searchText.lowercased()) )
            }
        )
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.reloadData()
        
        if isFiltering() {
            newURL = filteredDataFavs[indexPath.row].url
        } else {
            newURL = favs[indexPath.row].url
        }
        
        performSegue(withIdentifier: "segue1", sender: self)
    }
    
    @objc func openMenu() {
        self.navigationController?.navigationBar.isHidden = true
        let storyBoard: UIStoryboard = UIStoryboard(name: "Routes", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "NavigationViewControllerFavourites") as! MainNavigationFromFavouritesViewController
        self.present(mainViewController, animated: false, completion: nil)
    }
}

extension FavListTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
