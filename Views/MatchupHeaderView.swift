//   MatchupHeaderView.swift
//   MLBSchedule
//
//   Created by: Grant Perry on 6/25/24 at 1:19 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct MatchupHeaderView: View {
   var visitors: String
   var home: String

    var body: some View {
	   VStack {
		  HStack {
			 Spacer()
		     HStack {
			   Text(visitors)
				   .font(.title3)
				   .fontWeight(.bold)
				   .lineLimit(2)
				   .minimumScaleFactor(0.5)
				   .scaledToFit()

			 }
			 Spacer()
			 HStack {
				Text("vs.")
				   .font(.footnote)
				   .foregroundColor(.black)
			 }
			 Spacer()
			 HStack {
				Text(home)
				   .font(.title3)
				   .fontWeight(.bold)
				   .lineLimit(2)
				   .minimumScaleFactor(0.5)
				   .scaledToFit()
			 }
			 Spacer()
		  }

	   }
	   .frame(maxWidth: .infinity)
    }
}

#Preview {
   MatchupHeaderView(visitors: "New York Mets", home: "New York Yankees")
}
