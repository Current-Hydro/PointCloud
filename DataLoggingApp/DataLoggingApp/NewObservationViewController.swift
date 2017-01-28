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

class NewObservationViewController: UIViewController {
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