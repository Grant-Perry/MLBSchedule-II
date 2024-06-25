import SwiftUI

class ScheduleViewModel: ObservableObject {
   static let shared = ScheduleViewModel()
   @State var selectedDate: String = ""
   @State var events: [Event] = []
   @State var filteredEvents: [Event] = []

   
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
	  print("Loading schedule for date: \(dateString)")

	  let urlString = "https://www.espn.com/mlb/schedule/_/date/\(dateString)?_xhr=pageContent&refetchShell=false&offset=-04:00&original=date=\(dateString)&date=\(dateString)"

	  guard let url = URL(string: urlString) else { return }

	  var request = URLRequest(url: url)
	  let cookieHeader = "espn_S2=\(AppConstants.espn_S2); SWID=\(AppConstants.SWID)"
	  request.setValue(cookieHeader, forHTTPHeaderField: "Cookie")
	  request.httpShouldHandleCookies = true

	  URLSession.shared.dataTask(with: request) { data, response, error in
		 guard let data = data, error == nil else {
			print("Failed to fetch data: \(String(describing: error))")
			return
		 }

		 do {
			let scoreboard = try JSONDecoder().decode(Scoreboard.self, from: data)
			DispatchQueue.main.async {
			   print("Loaded events: \(scoreboard.events.count)")
			   self.events = scoreboard.events[dateString] ?? []
			   self.filteredEvents = self.events
			}
		 } catch {
			print("Failed to decode JSON: \(error)")
		 }
	  }.resume()
   }


    func extractDateAndTime(from dateString: String) -> (String, String) {
	  // Create a DateFormatter for parsing the input date string
	  let dateFormatter = DateFormatter()
	  dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
	  dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure it's parsed as UTC

	  if let date = dateFormatter.date(from: dateString) {
		 // Format start date
		 let dateFormatter = DateFormatter()
		 dateFormatter.dateFormat = "MMM d"
		 let startDate = dateFormatter.string(from: date)

		 // Format start time considering EST/EDT
		 let timeFormatter = DateFormatter()
		 timeFormatter.dateFormat = "h:mm a"
		 timeFormatter.timeZone = TimeZone.current
		 let startTime = timeFormatter.string(from: date)

		 return (startDate, startTime)
	  } else {
		 return ("N/A", "N/A")
	  }
   }

}
