//
//  Dates.swift
//  FU-HabitTracker
//
//  Created by Clara Toll on 2023-04-21.
//

import Foundation
import SwiftUI

struct Days : Codable {
    var habitID : String
    var completedDay : Date
    var done : Bool = false
}
