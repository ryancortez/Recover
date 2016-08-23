//
//  SavedExerciseList.swift
//  Recover
//
//  Created by Ryan Cortez on 8/19/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit
import CoreData

class SavedExerciseList: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var exercises: Set<Exercise> // Collection of exercises
}
