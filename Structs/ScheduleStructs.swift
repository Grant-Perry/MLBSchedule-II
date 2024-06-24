//   ScheduleStructs.swift
//   MLBSchedule
//
//   Created by: Grant Perry on 6/24/24 at 11:02 AM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

// data model structs for TeamScheduleView

struct Scoreboard: Codable {
   let events: [String: [Event]]
}

struct Event: Identifiable, Codable {
   let id: String
   let date: String
   let competitors: [Competitor]
   let link: String
   let venue: Venue
}

struct Competitor: Codable {
   let id: String
   let abbrev: String
   let displayName: String
   let shortDisplayName: String
   let logo: String
   let isHome: Bool
   let score: Int?
}

struct Venue: Codable {
   let fullName: String
}
