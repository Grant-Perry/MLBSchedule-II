//   MatchupView.swift
//   MLBSchedule
//
//   Created by: Grant Perry on 6/25/24 at 5:21 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct MatchupView: View {
   var event: Event

   var body: some View {
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

			   if let awayProbable = awayTeam.probable {
				  Link(awayProbable.shortName, destination: URL(string: awayProbable.href)!)
					 .font(.footnote)
				  //								 .centered()
			   }
			}
			Spacer(minLength: 10)
			if let homeLogoURL = URL(string: homeTeam.logo) {
			   asyncImageLoad(teamName: homeLogoURL)
			}

			if let homeProbable = homeTeam.probable {
			   Link(homeProbable.shortName, destination: URL(string: homeProbable.href)!)
				  .font(.footnote)
			   //							  .centered()
			}
		 }
	  }
	  .onTapGesture {
		 if let url = URL(string: "https://www.espn.com" + event.link) {
			UIApplication.shared.open(url)
		 }
	  }
   }
}
