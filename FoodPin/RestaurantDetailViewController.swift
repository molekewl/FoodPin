//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Johnny Mandela on 3/12/17.
//  Copyright © 2017 Johnny Mandela. All rights reserved.
//

import UIKit
import MapKit

// Added UITableViewDataSource & UITableViewDelegate to the Class *right click RDViewController source/delegate to tableView
class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    // Unwind Segue to go back from review page
    @IBAction func close(segue:UIStoryboardSegue) {
        
    }
    
    // *ctrl+click from X to exit* Changed Identity 3 segues to great, ok & dislike.
    @IBAction func ratingButtonTapped(segue: UIStoryboardSegue) {
        if let rating = segue.identifier {
            
            restaurant.isVisited = true // since user has dined there we updated it to true
            
            switch rating {
                case "great": restaurant.rating = "Absolutely love it! Must try."
                case "ok": restaurant.rating = "It's ok."
                case "dislike": restaurant.rating = "I don't like it."
            default: break
            }
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        
    }
    
    func showMap() {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantDetailTableViewCell
        
        //Configure the cell, Clicked Cell: changed class to RestaurantDetailViewController. Connect Field & Value label
        // Switch is used instead of if/else so when the first data matches it stops
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phone
        case 4:
            cell.fieldLabel.text = "Been Here"
            cell.valueLabel.text = (restaurant.isVisited) ? "Yes, I've been here before. \(restaurant.rating)": "No"
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        // Make cells transparent
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    // Establish a connection with the table view object in storyboard
    // Right clicked table View, + Source & Delegate to RestaurantDetail View controller
    @IBOutlet var tableView:UITableView!
    
    // Make connections to labels
    @IBOutlet var restaurantImageView:UIImageView!
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantTypeLabel: UILabel!
    @IBOutlet var restaurantLocationLabel: UILabel!
    
    var restaurant:Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // very light grey to the table cells
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        
        // clear table view footer. Turn off to use maps
        //tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // color of the separators for content rows
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        // Do any additional setup after loading the view.
        restaurantImageView.image = UIImage(named: restaurant.image)
        
        // navigationBar Restaurant Title Name
        title = restaurant.name
        
        // Enable self sizing cells for the detail view
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //closeView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        
        // To reconginze tap gesture, we need to initialize UITapGestureReconginizer object and attach it to the map view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location, completionHandler: { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                
                // Add annotation
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    //Display the annotation
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    // Set the zoom level
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: false)
                    
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReview" {
            let destinationController = segue.destination as! ReviewViewController
                destinationController.restaurant = restaurant

        } else if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // swipe hide navbar disable on detail view
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
