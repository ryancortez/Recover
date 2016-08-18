//
//  BodyPart.swift
//  Recover
//
//  Created by Ryan Cortez on 8/18/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import Foundation
import CoreData

class BodyPart: NSManagedObject {
    @NSManaged var name: String // Name of the body part
    @NSManaged var exercises: Set<Exercise> // Collection of exercises
}
