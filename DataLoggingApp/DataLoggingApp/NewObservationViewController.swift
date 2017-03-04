//
//  NewObservationViewController.swift
//  Hydroelectric App
//
//  Created by Jason Chang on 1/28/17.
//  Copyright © 2017 Jason Chang. All rights reserved.
//

import UIKit
import Parse
import Bolts
import MapKit
import CoreLocation

class NewObservationViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    // Outlets for text fields and image views
        // Get image after image is picked
    
    /// Set up for getting user location ///
    let locationManager = CLLocationManager()
    @IBOutlet weak var temperature: UITextField!
    @IBOutlet weak var weather: UITextField!
    @IBOutlet weak var trafficConditions: UITextField!
    @IBOutlet weak var crossingLocation: UITextField!
    @IBOutlet weak var liveOrDead: UITextField!
    @IBOutlet weak var species: UITextField!
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
        } else{
            print("There was a problem")
        }
        
        self.dismiss(animated: true) { 
            // Nothing happens after image is uploaded
        }
    }
    
    
    // Activity Indicator //
    var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y:0, width: 50, height:50))
    
    func pauseApp() {
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        view.isUserInteractionEnabled = false
    }
    
    func restoreApp() {
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    //
    
    
    // Function when image is uploaded
    @IBAction func uploadImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.allowsEditing = false
        
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func getWeather(){
        locationManager.requestLocation()
        locationManager.stopUpdatingLocation()
        
        self.pauseApp()
        
        let urlString = "https://api.darksky.net/forecast/9030fc9b86a5c76bd83ac199a0190219/\(userLatitude),\(userLongitude)"
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print(error ?? String())
            } else{
                do{
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: [])  as! [String:Any]
                    let currentConditions = parsedData["currently"] as! [String:Any]
                    
                    print (currentConditions)
                    
                    let currentTemperatureF = currentConditions["temperature"] as! Double
                    let weatherSummary = currentConditions["summary"] as! String
                    print(currentTemperatureF)
                    
                    self.temperature.text = "\(currentTemperatureF)"
                    self.weather.text = "\(weatherSummary)"
                    self.restoreApp()
                
                } catch let error as NSError{
                    print(error)
                    self.restoreApp()
                }
            }
            }.resume()
    }
    
    // Function for posting observation
    @IBAction func postObservation(_ sender: Any) {
        print("posting image")
        
        //getWeather()
        
        //pauseApp()
        
        if crossingLocation.text != "" && weather.text != ""{
        
            // Get image data and convert it to a PFFile
            let imageData = UIImagePNGRepresentation(imageView.image!)
            let imageFile = PFFile(name: "image.png", data: imageData!)
            let userObservation = PFObject(className: "Observations")
            
            // Prepare objects to be posted to server
            userObservation["imageFile"] = imageFile
            userObservation["temperature"] = temperature.text
            userObservation["weather"] = weather.text
            userObservation["trafficConditions"] = trafficConditions.text
            userObservation["crossingLocation"] = crossingLocation.text
            userObservation["liveOrDead"] = liveOrDead.text
            userObservation["species"] = species.text
            userObservation["crossingLocation"] = crossingLocation.text
            userObservation["userId"]=PFUser.current()?.objectId
            
            userObservation.saveInBackground(block: { (success, error) in
                if error == nil{
                    self.restoreApp()
                    self.displayAlert(title: "Upload Success!", message: "Observation uploaded successfully", buttonMessage: [("OK")])
                    self.weather.text=""
                    self.trafficConditions.text=""
                    self.crossingLocation.text=""
                    self.liveOrDead.text=""
                    self.weather.text=""
                    self.imageView.image = nil
                }else{
                    self.restoreApp()
                    var displayErrorMessage = "Please try again later"
                    if let errorMessage = (error! as NSError).userInfo["error"] as? String{
                        displayErrorMessage = errorMessage
                    }
                    self.displayAlert(title: "Error", message: displayErrorMessage, buttonMessage: ["OK"])

                }
            })
        }
        else{
            print("Check text fields")
            restoreApp()
            displayAlert(title: "Error", message: "You cannot have empty field(s)", buttonMessage: [("OK")])
        }
    }
    
    //Logout Function
    @IBAction func logoutButton(_ sender: Any) {
        
        // Logout user, and preform segue back to login page
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            // Preform segue back to loginpage, and logout user
            PFUser.logOut()
            self.performSegue(withIdentifier: "logoutSegue", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            // User doesn't want to logout, cancel action
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        }

    override func viewDidLoad() {
        // Setup for spinner //
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityIndicator.center = view.center;
        ///////////////////////
        
        
        // Setup for location services
        // Asking for authorization from user
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
        
        // Get user's current location
        super.viewDidLoad()
        
        //getWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error)
    }
    
    // Variables to hold the users latitude and longitude
    var userLatitude = 0.0
    var userLongitude = 0.0
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations:[CLLocation]){
        
        //let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        // Get the user's latitude and longitude
        //userLatitude = locValue.latitude
        //userLongitude = locValue.longitude
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
