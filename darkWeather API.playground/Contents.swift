//: Playground - noun: a place where people can play

import UIKit

let urlString = "https://api.darksky.net/forecast/9030fc9b86a5c76bd83ac199a0190219/37.8267,-122.4233"

let url = URL(string: urlString)
URLSession.shared.dataTask(with:url!) { (data, response, error) in
    if error != nil {
        print(error)
    } else {
        do {
            
            let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
            let currentConditions = parsedData["currently"] as! [String:Any]
            
            print(currentConditions)
            
            let currentTemperatureF = currentConditions["temperature"] as! Double
            print(currentTemperatureF)
        } catch let error as NSError {
            print(error)
        }
    }
    
    }.resume()