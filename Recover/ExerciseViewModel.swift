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
    var image: UIImage? 
    var reps: Int16? = 0 // Number of times exercise is performed
    var time: Int16? = 0 // Time it takes to do the exercise in seconds
    var sets: Int16? = 0 // Number of reps that should be done
    var instructions: String?
    var bodyPart: BodyPart!
    
    init(name: String, image: UIImage?, instructions: String?, bodyPart: BodyPart, reps: Int16?, sets: Int16?, time: Int16?) {
        super.init()
        self.name = name
        self.reps = reps
        self.sets = sets
        self.time = time
        self.instructions = instructions
        self.bodyPart = bodyPart
        self.image = image
    }
}
