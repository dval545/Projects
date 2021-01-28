//
//  DemoURLs.swift
//  Cassini
//
//  Created by Admin1 on 30/11/20.
//  Copyright © 2020 Admin1. All rights reserved.
//

import Foundation

struct DemoURLs{
    static var NASA: Dictionary<String,URL> = {
        let NASAURLStrings = [
            "Cassini" : "https://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg",
            "Earth": "https://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg",
            "Saturn": "https://www.nasa.gov/sites/default/files/satrun_collage.jpg"
        ]
        var urls = Dictionary<String,URL>()
        for (key, value) in NASAURLStrings{
            urls[key] = URL(string: value)
        }
        return urls
    }()
    
}
