//
//  VenueListViewController.swift
//  CaffeineKick
//
//  Created by Chesley Stephens on 12/23/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

import UIKit

class VenueListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var venues: [Venue]!
    var selectedVenue: Venue?
    
    var venueService: VenueService!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let venueDetailViewController = segue.destination as? VenueDetailViewController, segue.identifier == String(describing: VenueDetailViewController.self) {
            venueDetailViewController.venue = selectedVenue
            venueDetailViewController.venueService = venueService
        }
    }
}

// MARK: - UITableViewDataSource

extension VenueListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let venue = venues[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "VenueListCell", for: indexPath)
        cell.textLabel?.text = venue.name
        cell.detailTextLabel?.text =  venue.location.distanceInMiles
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension VenueListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedVenue = venues[indexPath.row]
        performSegue(withIdentifier: String(describing: VenueDetailViewController.self), sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

