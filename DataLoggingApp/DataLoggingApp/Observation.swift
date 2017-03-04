//
//  observation.swift
//  Hydroelectric App
//
//  Created by Jason Chang on 2/3/17.
//  Copyright © 2017 Jason Chang. All rights reserved.
//

import UIKit

class Observation{
    var title: String = ""
    var note: String = ""
    var image:UIImage?
    
    init(title:String, note:String, image:UIImage){
        self.title=title
        self.note=note
        self.image=image
    }
}
