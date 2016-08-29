//
//  Exercise.swift
//  Recover
//
//  Created by Ryan Cortez on 8/15/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Exercise: NSManagedObject {
    @NSManaged var image: NSData
    @NSManaged var name: String // Name of the exercise
    @NSManaged var reps: Int16 // Number of times exercise is performed
    @NSManaged var time: Int16 // Time it takes to do the exercise in seconds
    @NSManaged var instructions: String
    @NSManaged var savedExerciseList: SavedExerciseList
}
