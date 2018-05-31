//
//  MapController.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/25/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import UIKit
import MapKit

class NewCityController: UIViewController {
    var searchController: UISearchController!
    var annotation: MKAnnotation!
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    var modelDelegate: CitiesModel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func tapDoneButton(_ sender: Any) {
        guard let annotation = pointAnnotation else  {
            showAlert(title: "Error", message: "Please choose a city")
            return
        }
        
        modelDelegate.isValidCity(longitude: annotation.coordinate.longitude, latitude: annotation.coordinate.latitude) { isValid, city, error in
            DispatchQueue.main.async {
                if isValid {
                    self.showСonfirmAlert(title: city, message: "Would you like to add this city ?") {
                        if self.modelDelegate.addCity(city: city) {
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            self.showAlert(title: "Error", message: "We can not add \(city)")
                        }
                    }
                } else {
                    self.showAlert(title: "Error", message: "This city is not valid")
                }
            }
        }
    }
    
    @IBAction func showSearchBar(_ sender: Any) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.location(in: self.mapView)
            let location = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            self.pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = location
            removeAnnotations()
            mapView.addAnnotation(pointAnnotation)
        }
    }
    
    private func removeAnnotations() {
        mapView.annotations.forEach { annotation in
            mapView.removeAnnotation(annotation)
        }
    }
}

extension NewCityController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in

            if localSearchResponse == nil {
                self.showAlert(title: "Error", message: "Place Not Found")
                return
            }

            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)


            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
}








