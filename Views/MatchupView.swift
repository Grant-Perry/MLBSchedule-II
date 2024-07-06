import SwiftUI

struct MatchupView: View {
   var event: Event
   @EnvironmentObject var vm: ScheduleViewModel
   let theBounds = 0.15
   let theSummary = 12.0

   var body: some View {
	  VStack(alignment: .center, spacing: 5) {
		 if let awayCompetitor = event.competitions?.first?.competitors?.first(where: { $0.homeAway == "away" }),
			let homeCompetitor = event.competitions?.first?.competitors?.first(where: { $0.homeAway == "home" }) {

			HStack {
			   // Away Logo and Record
			   if let awayLogoURL = URL(string: awayCompetitor.team?.logo ?? "") {
				  VStack {
					 asyncImageLoad(teamName: awayLogoURL)
						.frame(width: UIScreen.main.bounds.width * theBounds)
						.frame(height: UIScreen.main.bounds.width * theBounds)
						.background(Color.clear)
						.clipShape(Circle())
						.overlay(Circle().stroke(Color.gray, lineWidth: 1))
						.frame(maxWidth: .infinity, alignment: .center)

					 if let record = awayCompetitor.records?.first {
						Text("(\(record.summary ?? "N/A"))")
						   .font(.system(size: theSummary))
						   .foregroundColor(.gray)
					 }

					 if let awayProbable = awayCompetitor.probables?.first {
						ProbablePitcherView(name: awayProbable.athlete?.displayName ?? "N/A", era: awayProbable.statistics?.first { $0.name == "ERA" }?.displayValue ?? "N/A", href: awayProbable.athlete?.links?.first?.href ?? "")
					 }
				  }
				  .fixedSize(horizontal: false, vertical: true)
			   }

			   // Middle Section
			   VStack(alignment: .center) {
				  let (formattedDate, formattedTime) = vm.extractDateAndTime(from: event.date)
				  Text("\(formattedTime)")
					 .font(.headline)
				  Text(event.competitions?.first?.venue?.fullName ?? "N/A")
					 .font(.system(size: 10))
			   }
			   .frame(maxHeight: .infinity, alignment: .center)
			   .padding(.top, -40) // move time & venue up a bit

			   // Home Logo and Record
			   if let homeLogoURL = URL(string: homeCompetitor.team?.logo ?? "") {
				  VStack {
					 asyncImageLoad(teamName: homeLogoURL)
						.frame(width: UIScreen.main.bounds.width * theBounds)
						.frame(height: UIScreen.main.bounds.width * theBounds)
						.background(Color.clear)
						.clipShape(Circle())
						.overlay(Circle().stroke(Color.gray, lineWidth: 1))
						.frame(maxWidth: .infinity, alignment: .center)

					 if let record = homeCompetitor.records?.first {
						Text("(\(record.summary ?? "N/A"))")
						   .font(.system(size: theSummary))
						   .foregroundColor(.gray)
					 }

					 if let homeProbable = homeCompetitor.probables?.first {
						ProbablePitcherView(name: homeProbable.athlete?.displayName ?? "N/A", era: homeProbable.statistics?.first { $0.name == "ERA" }?.displayValue ?? "N/A", href: homeProbable.athlete?.links?.first?.href ?? "")
					 }
				  }
				  .fixedSize(horizontal: false, vertical: true)
			   }
			}
		 }
	  }
	  .padding([.leading, .trailing], 10)
	  .padding(.vertical, 5)
//	  .background(Color(.systemGray6))
	  .background(LinearGradient(gradient: Gradient(colors: [.gpDark1, .gpDark2]),
								 startPoint: .bottom,
								 endPoint: .top))
	  .cornerRadius(10)
	  .shadow(radius: 2)
	  .onTapGesture {
		 if let urlString = event.links?.first?.href, let url = URL(string: urlString) {
			UIApplication.shared.open(url)
		 }
	  }
   }
}
