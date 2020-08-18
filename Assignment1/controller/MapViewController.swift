//
//  MapViewController.swift
//  Assignment1
//
//  Created by linshun on 3/2/20.
//  Copyright © 2020 Shunyang Dong. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    var user: User? {
        didSet {
            
        }
    }
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var camera = GMSCameraPosition()
    let geocoder = CLGeocoder()
    var placemark:CLPlacemark?
    var text:String = ""
    var isperformedreverseGeocoding = false
    var lastGeocodingError: Error?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send Location", style: .plain, target: self, action: #selector(handleSend))
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 15.0)
        
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        
        
        // Creates a marker in the center of the map.
        
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        
        // self.locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        
        
    }
    @objc func handleSend()
    {
        
        
        if(self.placemark?.subThoroughfare != nil){
            text = self.placemark?.subThoroughfare! as! String + "," + (self.placemark?.thoroughfare)! as! String + ","  + (self.placemark?.locality)! as! String + "," + (self.placemark?.administrativeArea)! as! String + ","  + (self.placemark?.postalCode)! as! String + ","  + (self.placemark?.country)! as! String
            
            let properties = ["text":text]
                         sendMessageWithProperties(properties as [String : AnyObject])
          
            
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Please enable the location", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    fileprivate func sendMessageWithProperties(_ properties: [String: AnyObject]) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
         let toId = user!.id!
     
        let fromId = getFromID()
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var values: [String: AnyObject] = ["toId": toId as AnyObject, "fromId": fromId as AnyObject, "timestamp": timestamp as AnyObject]
        
        //append properties dictionary onto values somehow??
        //key $0, value $1
        properties.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
           
            
            guard let messageId = childRef.key else { return }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId!).child(toId).child(messageId)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId!).child(messageId)
            recipientUserMessagesRef.setValue(1)
            
            let alert = UIAlertController(title: "Alert", message: "Current Address are sent", preferredStyle: UIAlertController.Style.alert)
                             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                             self.present(alert, animated: true, completion: nil)
        }
    }

    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locationManager.location?.coordinate
        placemark = nil
        lastGeocodingError = nil
        currentLocation = locations.last!
        if currentLocation != nil
        {
            if !isperformedreverseGeocoding
            {
           
                isperformedreverseGeocoding = true
                geocoder.reverseGeocodeLocation(currentLocation!, completionHandler: {(placemarks,error)in
                    
                    self.lastGeocodingError = error
                    if error == nil, let placemarks = placemarks ,!placemarks.isEmpty
                    {
                        self.placemark = placemarks.last!
                        
                        
                    }
                    else
                    {
                        self.placemark = nil
                    }
                    self.isperformedreverseGeocoding = false
                    
                }
                    
                )
            }
        }
        cameraMoveToLocation(toLocation: location)
        locationManager.stopUpdatingLocation()
        
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
            let marker = GMSMarker()
            marker.position = toLocation!
            marker.title = "Sydney"
            marker.snippet = "Australia"
            marker.map = mapView
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        
    }
    
}
