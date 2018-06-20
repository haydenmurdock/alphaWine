//
//  MapViewController.swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/19/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
        let regionRadius: CLLocationDistance = 1000
        var selectedPin:MKPlacemark? = nil
        
        var resultSearchController:UISearchController? = nil
        
        let locationManager = CLLocationManager()
    
    var beverage: Beverage?
        

 
        
        override func viewDidLoad() {
            super.viewDidLoad()
           
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            let location = locationManager.location
            centerMapOnLocation(location: location!)
            mapView.delegate = self
            let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableController
            resultSearchController = UISearchController(searchResultsController: locationSearchTable)
            resultSearchController?.searchResultsUpdater = locationSearchTable
            let searchBar = resultSearchController!.searchBar
            searchBar.placeholder = "Enter Winery"
            searchBar.sizeToFit()
            searchBar.text = beverage?.producer_name
            navigationItem.titleView = resultSearchController?.searchBar
            resultSearchController?.hidesNavigationBarDuringPresentation = false
            resultSearchController?.dimsBackgroundDuringPresentation = true
            definesPresentationContext = true
            locationSearchTable.mapView = mapView
            locationSearchTable.handleMapSearchDelegate = self
        
        }
        
       @objc func getDirections(){
            if let selectedPin = selectedPin {
                let mapItem = MKMapItem(placemark: selectedPin)
                let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                mapItem.openInMaps(launchOptions: launchOptions)
            }
        }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}
    
    extension MapViewController : CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error:: \(error.localizedDescription)")
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                locationManager.requestLocation()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            
        }

    }
    
    extension MapViewController: HandleMapSearch {
        func dropPinZoomIn(placemark:MKPlacemark){
            // cache the pin
            selectedPin = placemark
            // clear existing pins
            mapView.removeAnnotations(mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            if let city = placemark.locality,
                let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    extension MapViewController : MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.pinTintColor = Colors.darkGreen
            pinView?.canShowCallout = true
            let smallSquare = CGSize(width: 30, height: 30)
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            button.setBackgroundImage(UIImage(named: "car"), for: .normal)
            button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
            pinView?.leftCalloutAccessoryView = button
            return pinView
        }
    }

