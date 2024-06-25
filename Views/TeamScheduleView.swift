import SwiftUI

struct TeamScheduleView: View {
   let vm = ScheduleViewModel.shared

   var body: some View {
	  NavigationView {
		 VStack {
			// Date Selector
			ScrollView(.horizontal) {
			   DateButtonView()
			}
			.padding(.top, 8)
			.padding(.bottom, 8)
			Spacer()
			HStack {
			   Text(vm.headerDateFormatter.string(from: vm.dateFormatter.date(from: vm.selectedDate) ?? Date()))
				  .font(.title2)
				  .padding(.leading)
			   Spacer()
			}
			// Team Schedule List
			if vm.filteredEvents.isEmpty {
			   ProgressView()
			} else {
			   List(vm.filteredEvents, id: \.id) { event in
				  HStack(alignment: .center) {
					 if let awayTeam = event.competitors.first(where: { !$0.isHome }),
						let homeTeam = event.competitors.first(where: { $0.isHome }) {
						if let awayLogoURL = URL(string: awayTeam.logo) {
						   asyncImageLoad(teamName: awayLogoURL)
						}
						Spacer(minLength: 10)
						// Matchup Text

						VStack(alignment: .center) {
						   MatchupHeaderView(visitors: awayTeam.displayName, 
											 home: homeTeam.displayName)

						   let (formattedDate, formattedTime) = vm.extractDateAndTime(from: event.date)
						   Text("\(formattedDate) at \(formattedTime)")
							  .font(.subheadline)
						}
						Spacer(minLength: 10)
						if let homeLogoURL = URL(string: homeTeam.logo) {

						   asyncImageLoad(teamName: homeLogoURL)
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
			vm.selectedDate = vm.dateFormatter.string(from: today)
			vm.loadSchedule(for: today)
		 }
		 // .navigationTitle("Team Schedule")
		 .preferredColorScheme(.dark)
	  }
   }
}

// Preview
#Preview {
   TeamScheduleView()
}



struct asyncImageLoad: View {
   let teamName: URL

   var body: some View {
	  AsyncImage(url: teamName) { image in
		 image.resizable()
			.scaledToFit()
			.frame(width: 70)
			.background(Color.clear)
			.clipShape(Circle())
			.overlay(Circle().stroke(Color.gray, lineWidth: 1))
	  } placeholder: {
		 ProgressView()
	  }
   }
}
