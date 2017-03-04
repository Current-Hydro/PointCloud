//
//  SavedObservationsViewController.swift
//  Hydroelectric App
//
//  Created by Jason Chang on 1/28/17.
//  Copyright © 2017 Jason Chang. All rights reserved.
//

import UIKit
import Parse
import Bolts

class SavedObservationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var observations = [Observation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let userId = PFUser.current()?.objectId
        
        let query = PFQuery(className: "Observations")
        // Change key to where userId
        query.whereKey("userId", equalTo: userId ?? String())
        query.findObjectsInBackground { (objects, error) in
            if let objects = objects{
                for object in objects{
                    // Retrieve image from object
                    let imageFile = object["imageFile"] as! PFFile
                    imageFile.getDataInBackground(block: { (imageData, error) in
                        if error == nil {
                            if let imageData = imageData {
                                let image = UIImage(data:imageData)
                                
                                // Append to observations array
                                print(object.objectId ?? "hello")
                                let appendedNote = "The temperature is \(object["temperature"] as! String) and the species \(object["species"] as! String) was at \(object["crossingLocation"] as! String) and was \(object["liveOrDead"] as! String) and the weather was \(object["weather"] as! String)"
                                //self.observations.append(Observation(title:object["crossingLocation"] as! String,note:object["temperature"] as! String,image:image!))
                                self.observations.append(Observation(title:object["species"] as! String,note:appendedNote,image:image!))
                                
                                self.tableView.reloadData()
                                print(self.observations.count)

                            }
                        }
                    })
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //return UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedTableViewCell
        
        cell.observationTitle.text = observations[indexPath.row].title
        cell.observationNote.text = observations[indexPath.row].note
        cell.observationImage.image = observations[indexPath.row].image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Cell selected code here
    }
 
    //
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
