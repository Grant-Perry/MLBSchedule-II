import SwiftUI

class ScheduleViewModel: ObservableObject {
   static let shared = ScheduleViewModel()
   @Published var selectedDate: String = ""
   @Published var events: [TeamSchedule.Event] = []
   @Published var filteredEvents: [TeamSchedule.Event] = []

//class ScheduleViewModel: ObservableObject {
//   static let shared = ScheduleViewModel()
//   @Published var selectedDate: String = ""
//   @Published var events: [Event] = []
//   @Published var filteredEvents: [Event] = []

   let dateFormatter: DateFormatter = {
	  let formatter = DateFormatter()
	  formatter.dateFormat = "yyyyMMdd"
	  formatter.timeZone = TimeZone.current
	  return formatter
   }()

   let headerDateFormatter: DateFormatter = {
	  let formatter = DateFormatter()
	  formatter.dateFormat = "EEEE MMMM d ' | Games'"
	  formatter.timeZone = TimeZone.current
	  return formatter
   }()

   let eventDateFormatter: DateFormatter = {
	  let formatter = DateFormatter()
	  formatter.dateFormat = "MMM d 'at' h:mm a"
	  formatter.timeZone = TimeZone.current
	  return formatter
   }()

   var bottomPadding: CGFloat {
	  UIApplication.shared.connectedScenes
		 .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
		 .first { $0.isKeyWindow }?.safeAreaInsets.bottom ?? 0
   }

   func formattedDateButton(for day: Int) -> String {
	  let date = Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()
	  let formatter = DateFormatter()
	  formatter.dateFormat = "MMM d\n(E)"
	  return formatter.string(from: date)
   }

   func formattedEventDate(_ date: String) -> String {
	  let formatter = ISO8601DateFormatter()
	  formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
	  guard let date = formatter.date(from: date) else { return date }
	  return eventDateFormatter.string(from: date)
   }

   func loadSchedule(for date: Date) {
	  let dateString = dateFormatter.string(from: date)
//	  print("Loading schedule for date: \(dateString)")

	  let urlString = "https://site.api.espn.com/apis/site/v2/sports/baseball/mlb/scoreboard?dates=\(dateString)"
	  guard let url = URL(string: urlString) else {
		 print("Invalid URL")
		 return
	  }

	  var request = URLRequest(url: url)
	  let cookieHeader = "espn_S2=\(AppConstants.espn_S2); SWID=\(AppConstants.SWID)"
	  request.setValue(cookieHeader, forHTTPHeaderField: "Cookie")
	  request.httpShouldHandleCookies = true

	  URLSession.shared.dataTask(with: request) { data, response, error in
		 if let error = error {
			print("Failed to fetch data: \(error)")
			return
		 }

		 guard let data = data else {
			print("No data received")
			return
		 }

		 // Debug print the raw JSON data
		 if let jsonString = String(data: data, encoding: .utf8) {
//			print("Raw JSON data: \(jsonString)")
		 } else {
			print("Failed to decode raw JSON data to string")
		 }

		 do {
			let scoreboard = try JSONDecoder().decode(TeamSchedule.Scoreboard.self, from: data)
			DispatchQueue.main.async {
			   if let events = scoreboard.events {
//				  print("Loaded events: \(events.count)")
				  for event in events {
					 print("Event ID: \(event.id), Date: \(event.date)")
					 if let competitions = event.competitions {
						for competition in competitions {
						   if let competitors = competition.competitors {
							  print("Competitors count: \(competitors.count)")
							  for competitor in competitors {
								 print("Competitor: \(competitor.team?.displayName ?? "N/A"), Record: \(String(describing: competitor.team?.records))")
							  }
						   } else {
							  print("No competitors found for event ID: \(event.id)")
						   }
						}
					 } else {
						print("No competitions found for event ID: \(event.id)")
					 }
				  }
				  self.events = events
				  self.filteredEvents = events
			   } else {
				  print("No events found")
			   }
			}
		 } catch {
			print("Failed to decode JSON: \(error)")
		 }
	  }.resume()
   }

   func extractDateAndTime(from dateString: String) -> (String, String) {
	  let dateFormatter = DateFormatter()
	  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
	  dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

	  if let date = dateFormatter.date(from: dateString) {
		 let dateFormatter = DateFormatter()
		 dateFormatter.dateFormat = "MMM d"
		 let startDate = dateFormatter.string(from: date)

		 let timeFormatter = DateFormatter()
		 timeFormatter.dateFormat = "h:mm a"
		 timeFormatter.timeZone = TimeZone.current
		 let startTime = timeFormatter.string(from: date)

		 return (startDate, startTime)
	  } else {
		 return ("N/A", "N/A")
	  }
   }

   func getAppVersion() -> String {
	  if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
		 return version
	  } else {
		 return "Unknown version"
	  }
   }
}

