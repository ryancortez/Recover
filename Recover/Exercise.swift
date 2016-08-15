//
//  Exercise.swift
//  Recover
//
//  Created by Ryan Cortez on 8/15/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import Foundation

class Exercise: NSObject {
    var name: String = "" // Name of the exercise
    var reps: Int? // Number of times exercise is performed
    var time: Int? // Time it takes to do the exercise in seconds
    var bodyPartCategories: Array<String> = [] // Places on the body the exercise focuses on
    
    init(name: String, bodyPartCategories: Array<String>, reps: Int?, time: Int?) {
        super.init()
        self.name = name
        self.reps = reps
        self.time = time
        self.bodyPartCategories = bodyPartCategories
    }
}
