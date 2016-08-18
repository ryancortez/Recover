//
//  ExerciseViewModel.swift
//  Recover
//
//  Created by Ryan Cortez on 8/16/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class ExerciseViewModel: NSObject {
    var name: String = "" // Name of the exercise
    var image: UIImage? = UIImage()
    var reps: Int16? = 0 // Number of times exercise is performed
    var time: Int16? = 0 // Time it takes to do the exercise in seconds
    var instructions: String?
    
    init(name: String, image: UIImage?, instructions: String?, reps: Int16?, time: Int16?) {
        super.init()
        self.name = name
        self.reps = reps
        self.time = time
        self.instructions = instructions
    }
}
