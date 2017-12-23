
//  VenueDetailViewController.swift
//  CaffeineKick
//
//  Created by Chesley Stephens on 12/23/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

import UIKit
import Kingfisher

class VenueDetailViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var venue: Venue!
    var venueService: VenueService!
    
    var photos = [Photo]()
    var hours: Hours?
    
    var rowMap = [RowMapItems]()
    
    enum RowMapItems: Int {
        case distance
        case address
        case checkIns
        case hours
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = venue.name
        tableView.allowsSelection = false
        configureRowMap()
        
        venueService.retrieveVenuePhotos(venueId: venue.id) { [weak self] photos in
            if let photos = photos, photos.count > 0 {
                self?.photos = photos
                DispatchQueue.main.async {
                    self?.collectionViewHeightConstraint.constant = 128
                    self?.collectionView.reloadData()
                }
            }
        }
        venueService.retrieveVenueHours(venueId: venue.id) { [weak self] hours in
            if let hours = hours {
                self?.hours = hours
                self?.configureRowMap()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func configureRowMap() {
        rowMap.removeAll()
        
        rowMap.append(.distance)
        if venue.location.address != nil {
            rowMap.append(.address)
        }
        rowMap.append(.checkIns)
        if hours?.timeframes != nil {
            rowMap.append(.hours)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension VenueDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let venueDetailImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: VenueDetailImageCell.self), for: indexPath) as? VenueDetailImageCell {
            let photo = photos[indexPath.row]
            let url = URL(string: "\(photo.prefix!)\(photo.height!)x\(photo.width!)\(photo.suffix!)")
            venueDetailImageCell.imageView.kf.indicatorType = .activity
            venueDetailImageCell.imageView.kf.setImage(with: url)
            cell = venueDetailImageCell
        }
        
        return cell
    }
}

// MARK: - UITableViewDataSource

extension VenueDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowMap.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "VenueDetailCell", for: indexPath)
        switch rowMap[indexPath.row] {
        case .distance:
            cell.textLabel?.text = NSLocalizedString("Distance", comment: "")
            cell.detailTextLabel?.text = venue.location.distanceInMiles
        case .address:
            cell.textLabel?.text = NSLocalizedString("Address", comment: "")
            cell.detailTextLabel?.text = venue.location.address
        case .checkIns:
            cell.textLabel?.text = NSLocalizedString("Check-Ins", comment: "")
            cell.detailTextLabel?.text = "\(venue.stats.checkinsCount!)"
        case .hours:
            if let hours = hours, let hoursCell = tableView.dequeueReusableCell(withIdentifier: String(describing: VenueDetailHoursCell.self), for: indexPath) as? VenueDetailHoursCell {
                hoursCell.hoursLabel.text = hours.formatHoursString()
                cell = hoursCell
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension VenueDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
