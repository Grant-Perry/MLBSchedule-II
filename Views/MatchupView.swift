import SwiftUI

struct MatchupView: View {
   var event: Event
   @EnvironmentObject var vm: ScheduleViewModel
   let theBounds = 0.15

   var body: some View {
	  VStack(alignment: .center, spacing: 5) {
		 if let awayTeam = event.competitors.first(where: { !$0.isHome }),
			let homeTeam = event.competitors.first(where: { $0.isHome }) {

//			MatchupHeaderView(visitors: awayTeam.displayName, home: homeTeam.displayName)
//			   .padding(.bottom, 5)
//			   .multilineTextAlignment(.center)
//			   .lineLimit(2)

			HStack {
			   // Away Logo and Record
			   if let awayLogoURL = URL(string: awayTeam.logo) {
				  VStack {
					 asyncImageLoad(teamName: awayLogoURL)
						.frame(width: UIScreen.main.bounds.width * theBounds)
						.frame(height: UIScreen.main.bounds.width * theBounds)
						.background(Color.clear)
						.clipShape(Circle())
						.overlay(Circle().stroke(Color.gray, lineWidth: 1))
						.frame(maxWidth: .infinity, alignment: .center)

//					 if let record = awayTeam.record {
//						Text(record)
//						   .font(.footnote)
//						   .frame(maxWidth: .infinity, alignment: .center)
//					 }

					 if let awayProbable = awayTeam.probable {
						ProbablePitcherView(name: awayProbable.shortName, era: awayProbable.era, href: awayProbable.href, alignment: .center)
					 }
				  }
				  .fixedSize(horizontal: false, vertical: true)
			   }

			   // Middle Section
			   VStack(alignment: .center) {
				  let (formattedDate, formattedTime) = vm.extractDateAndTime(from: event.date)
				  Text("\(formattedTime)")
					 .font(.headline)
				  Text(event.venue.fullName)
					 .font(.system(size: 10))
			   }
			   .frame(maxHeight: .infinity, alignment: .center)
			   .padding(.top, -40) // move time & venue up a bit

			   // Home Logo and Record
			   if let homeLogoURL = URL(string: homeTeam.logo) {
				  VStack {
					 asyncImageLoad(teamName: homeLogoURL)
						.frame(width: UIScreen.main.bounds.width * theBounds)
						.frame(height: UIScreen.main.bounds.width * theBounds)
						.background(Color.clear)
						.clipShape(Circle())
						.overlay(Circle().stroke(Color.gray, lineWidth: 1))
						.frame(maxWidth: .infinity, alignment: .center)

//					 if let record = homeTeam.record {
//						Text(record)
//						   .font(.footnote)
//						   .frame(maxWidth: .infinity, alignment: .center)
//					 }

					 if let homeProbable = homeTeam.probable {
						ProbablePitcherView(name: homeProbable.shortName, era: homeProbable.era, href: homeProbable.href, alignment: .leading)
					 }
				  }
				  .fixedSize(horizontal: false, vertical: true)
			   }
			} // End of HStack
		 }
	  } // End of VStack
	  .padding([.leading, .trailing], 10)
	  .padding(.vertical, 5)
	  .background(Color(.systemGray6))
	  .cornerRadius(10)
	  .shadow(radius: 2)
	  .onTapGesture {
		 if let url = URL(string: "https://www.espn.com" + event.link) {
			UIApplication.shared.open(url)
		 }
	  }
   }
}

// Helper View for Probable Pitcher
struct ProbablePitcherView: View {
   var name: String
   var era: String?
   var href: String
   var alignment: HorizontalAlignment

   var body: some View {
	  VStack {
		 Link(name, destination: URL(string: href)!)
			.font(.system(size: 11))
			.frame(maxWidth: .infinity, alignment: .center) // Convert here
			.padding(.top, 3)
//			.fixedSize(horizontal: false, vertical: true)

		 Text("ERA: \(era ?? "N/A")")
			.font(.system(size: 9))
			.frame(maxWidth: .infinity, alignment: .center) // Convert here
//			.fixedSize(horizontal: false, vertical: true)
	  }
   }
}

// Extension to convert HorizontalAlignment to Alignment
extension HorizontalAlignment {
   func toAlignment() -> Alignment {
	  switch self {
		 case .leading: return .leading
		 case .center: return .center
		 case .trailing: return .trailing
		 default: return .center // Handle unexpected cases
	  }
   }
}
