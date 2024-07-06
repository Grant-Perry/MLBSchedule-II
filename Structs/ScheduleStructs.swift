import SwiftUI

struct Scoreboard: Codable {
   let events: [Event]?
}

struct Event: Identifiable, Codable {
   let id: String
   let date: String
   let competitions: [Competition]?
   let links: [LinkDetail]?
}

struct Competition: Codable {
   let competitors: [Competitor]?
   let venue: Venue?
}

struct Competitor: Codable {
   let homeAway: String?
   let team: Team?
   let probables: [Probable]?
   let records: [Record]?
}

struct Team: Codable {
   let displayName: String?
   let logo: String?
   let records: [Record]?
}

struct Probable: Codable {
   let athlete: Athlete?
   let statistics: [Statistic]?
}

struct Athlete: Codable {
   let displayName: String?
   let links: [LinkDetail]?
}

struct Statistic: Codable {
   let name: String?
   let displayValue: String?
}

struct Record: Codable {
   let summary: String?
}

struct LinkDetail: Codable {
   let href: String?
}

struct Venue: Codable {
   let fullName: String?
}
