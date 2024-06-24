import SwiftUI

struct TeamScheduleView: View {
   @State private var selectedDate: String = ""
   @State private var events: [Event] = []
   @State private var filteredEvents: [Event] = []

   var body: some View {
	  NavigationView {
		 VStack {
			// Display the selected date


			// Date Selector
			ScrollView(.horizontal) {
			   
			   HStack {
				  ForEach(0..<7, id: \.self) { day in
					 Button(action: {
						let newSelectedDate = Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()
						selectedDate = dateFormatter.string(from: newSelectedDate)
						loadSchedule(for: newSelectedDate)
					 }) {
						Text(formattedDateButton(for: day))
						   .frame(width: 70)
						   .padding()
						   .background(selectedDate == dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()) ? Color.blue : Color.clear)
						   .foregroundColor(selectedDate == dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()) ? .white : .black)
						   .cornerRadius(8)
						   .multilineTextAlignment(.center)
					 }
					 .background(.blue.gradient)
					 .opacity(0.5)
					 .cornerRadius(10.0)
				  }
			   }
			}
			.padding(.top, 8)
			.padding(.bottom, 8)
			Spacer()
			HStack {
			   Text(headerDateFormatter.string(from: dateFormatter.date(from: selectedDate) ?? Date()))
				  .font(.title2)
				  .padding(.leading)
			   Spacer()
			}
//			.padding(.top)
// Team Schedule List
			if filteredEvents.isEmpty {
			   ProgressView()
			} else {
			   List(filteredEvents, id: \.id) { event in
				  HStack(alignment: .center) {
					 if let awayTeam = event.competitors.first(where: { !$0.isHome }),
						let homeTeam = event.competitors.first(where: { $0.isHome }) {
						if let awayLogoURL = URL(string: awayTeam.logo) {
						   AsyncImage(url: awayLogoURL) { image in
							  image.resizable()
								 .scaledToFit()
								 .frame(width: 50)
								 .background(Color.clear)
								 .clipShape(Circle())
								 .overlay(Circle().stroke(Color.gray, lineWidth: 1))
						   } placeholder: {
							  ProgressView()
						   }
						}
						Spacer(minLength: 10)
						// Matchup Text
						VStack(alignment: .center) {
						   Text("\(awayTeam.displayName)")
							  .font(.headline.bold())
							  .lineLimit(1)
							  .minimumScaleFactor(0.5)
							  .scaledToFit()

						   Text("vs.")
							  .font(.body)
						   Text("\(homeTeam.displayName)")
							  .font(.headline.bold())

						   let venueName = event.venue.fullName
						   Text("at \(venueName)")
							  .font(.subheadline)
							  .lineLimit(2)
							  .minimumScaleFactor(0.7)
							  .scaledToFit()
							  .frame(maxWidth: .infinity)

						   let (formattedDate, formattedTime) = extractDateAndTime(from: event.date)
						   Text("\(formattedDate) at \(formattedTime)")
							  .font(.subheadline)
						}
						Spacer(minLength: 10)
						if let homeLogoURL = URL(string: homeTeam.logo) {
						   AsyncImage(url: homeLogoURL) { image in
							  image.resizable()
								 .scaledToFit()
								 .frame(width: 50)
								 .background(Color.clear)
								 .clipShape(Circle())
								 .overlay(Circle().stroke(Color.gray, lineWidth: 1))
						   } placeholder: {
							  ProgressView()
						   }
						}
					 }
				  }
				  .onTapGesture {
					 if let url = URL(string: "https://www.espn.com" + event.link) {
						UIApplication.shared.open(url)
					 }
				  }
			   }
//			   .padding(.bottom, bottomPadding)
			   .padding(.top, -18)
			}
		 }
		 .onAppear {
			let today = Date()
			selectedDate = dateFormatter.string(from: today)
			loadSchedule(for: today)
		 }
		 // .navigationTitle("Team Schedule")
		 .preferredColorScheme(.dark)
	  }
   }

   private let dateFormatter: DateFormatter = {
	  let formatter = DateFormatter()
	  formatter.dateFormat = "yyyyMMdd"
	  formatter.timeZone = TimeZone.current
	  return formatter
   }()

   private let headerDateFormatter: DateFormatter = {
	  let formatter = DateFormatter()
	  formatter.dateFormat = "EEEE MMMM d ' | Games'"
	  formatter.timeZone = TimeZone.current
	  return formatter
   }()

   private let eventDateFormatter: DateFormatter = {
	  let formatter = DateFormatter()
	  formatter.dateFormat = "MMM d 'at' h:mm a"
	  formatter.timeZone = TimeZone.current
	  return formatter
   }()

   private var bottomPadding: CGFloat {
	  UIApplication.shared.connectedScenes
		 .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
		 .first { $0.isKeyWindow }?.safeAreaInsets.bottom ?? 0
   }

   private func formattedDateButton(for day: Int) -> String {
	  let date = Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()
	  let formatter = DateFormatter()
	  formatter.dateFormat = "MMM d\n(E)"
	  return formatter.string(from: date)
   }

   private func formattedEventDate(_ date: String) -> String {
	  let formatter = ISO8601DateFormatter()
	  formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
	  guard let date = formatter.date(from: date) else { return date }
	  return eventDateFormatter.string(from: date)
   }

   private func loadSchedule(for date: Date) {
	  let dateString = dateFormatter.string(from: date)
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
			   self.events = scoreboard.events[dateString] ?? []
			   self.filteredEvents = self.events
			}
		 } catch {
			print("Failed to decode JSON: \(error)")
		 }
	  }.resume()
   }

   private func extractDateAndTime(from dateString: String) -> (String, String) {
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

// Preview
#Preview {
   TeamScheduleView()
}
