//import Foundation
//import SwiftUI
//import Combine
//
//class MLBTeamSchedulesViewModel: ObservableObject {
//   @Published var teams: [String: [String: String]] = [:]
//   @Published var errorMessage: String? = nil
//
//   func fetchMLBTeamSchedules() {
//	  let urlString = "https://site.web.api.espn.com/apis/v2/scoreboard/header?sport=baseball&league=mlb&region=us&lang=en&contentorigin=espn&buyWindow=1m&showAirings=buy%2Clive%2Creplay&showZipLookup=true&tz=America%2FNew_York"
//	  guard let url = URL(string: urlString) else {
//		 DispatchQueue.main.async {
//			self.errorMessage = "Invalid URL."
//		 }
//		 return
//	  }
//
//	  var request = URLRequest(url: url)
//	  let cookieHeader = """
//		espnS2=AECFGAfQ7Py28qa0LEBVDRkBiK9pWc4W%2BxdjwA2PKAxFPlRozIGXXV2IdUq5EN2hnqrdoi3dt8ZLxtD46vbmdOLArm%2Bsfmo2s9JmdreIpDUcDB9Kfo3lDva6Frus9TwAHSYr%2BtHZaEDb9Fg95ALUJCvTx%2BN7Oj5MMB63Qog2FjinR%2BSOmclTEfucTk9vR69lE8omIoBYCaGgKJCxJ%2FwuA3rxOD%2BhmZgOl%2Fo8VvBnEhSRS%2FFmLAwDFaRcnDPGP%2B9tuas1ZMW2FUfqbUUP6f%2F%2B0NzyR71mIqeFJk2a%2FX9CxTyzzkcMs3pBFiF2ApvVhcvcLdE%3D; SWID={7D6C3526-D30A-4DBD-9849-3D9C03333E7C}
//		"""
//	  request.setValue(cookieHeader, forHTTPHeaderField: "Cookie")
//	  request.httpShouldHandleCookies = true
//
//	  URLSession.shared.dataTask(with: request) { data, response, error in
//		 if let error = error {
//			DispatchQueue.main.async {
//			   self.errorMessage = "Request error: \(error.localizedDescription)"
//			}
//			return
//		 }
//
//		 guard let httpResponse = response as? HTTPURLResponse, let data = data else {
//			DispatchQueue.main.async {
//			   self.errorMessage = "No data received."
//			}
//			return
//		 }
//
//		 if (200...299).contains(httpResponse.statusCode) {
//			if let dataString = String(data: data, encoding: .utf8) {
//			   print("Data: \(dataString)")
//			}
//
//			do {
//			   let response = try JSONDecoder().decode(Response.self, from: data)
//			   var teams: [String: [String: String]] = [:]
//
//			   for event in response.events {
//				  for competitor in event.competitors {
//					 let teamName = competitor.team.displayName
//					 let opponent = event.competitors.first { $0.id != competitor.id }?.team.displayName ?? "Unknown"
//					 let venue = event.venue?.fullName ?? "Unknown"
//					 let status = event.status.type.description
//
//					 if teams[teamName] == nil {
//						teams[teamName] = [:]
//					 }
//					 teams[teamName]?[event.date] = "Opponent: \(opponent), Venue: \(venue), Status: \(status)"
//				  }
//			   }
//
//			   DispatchQueue.main.async {
//				  self.teams = teams
//				  self.errorMessage = nil
//			   }
//
//			} catch {
//			   DispatchQueue.main.async {
//				  self.errorMessage = "Failed to parse JSON: \(error.localizedDescription)"
//			   }
//			}
//		 } else {
//			DispatchQueue.main.async {
//			   self.errorMessage = "HTTP Error: \(httpResponse.statusCode)"
//			}
//		 }
//	  }.resume()
//   }
//}
