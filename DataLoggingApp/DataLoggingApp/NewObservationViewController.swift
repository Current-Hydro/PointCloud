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
