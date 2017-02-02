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

class NewObservationViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // Outlets for text fields and image views
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    // Get image after image is picked
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
    
    
    // Activity Indicator for activating app spinner
    var activityIndicator = UIActivityIndicatorView()
    func pauseApp(){
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x:0,y:0,width:50,height:50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func restoreApp(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    ////
    
    // Function when image is uploaded
    @IBAction func uploadImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.allowsEditing = false
        
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    
    // Function for posting observation
    @IBAction func postObservation(_ sender: Any) {
        print("posting image")
        pauseApp()
        if textField.text != "" && textView.text != "" && imageView.image != nil{
            if let image = imageView.image as UIImage!{
                let imageData = UIImagePNGRepresentation(image)
                let imageFile = PFFile(name: "image.png", data: imageData!)
                
                let userObservation = PFObject(className: "UserObservations")
                userObservation["imageFile"] = imageFile
                userObservation["title"] = textField.text
                userObservation["note"]=textView.text
                userObservation.saveInBackground(block: { (success, error) in
                    if error == nil{
                        self.restoreApp()
                        self.displayAlert(title: "Upload Success!", message: "Observation uploaded successfully", buttonMessage: [("OK")])
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
        }
        else{
            print("Check text fields")
        }
        restoreApp()
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
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
