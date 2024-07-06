import SwiftUI

struct MatchupHeaderView: View {
   var visitors: Competitor
   var home: Competitor

   var body: some View {
	  HStack {
		 VStack {
			Text(visitors.team?.displayName ?? "nothing yet")
			   .font(.title3)
			   .lineLimit(2)
			   .minimumScaleFactor(0.5)
			   .frame(maxWidth: .infinity, alignment: .center)
			   .frame(width: UIScreen.main.bounds.width * 0.35)
			   .multilineTextAlignment(.center)
			   .padding(.leading)
			if let visitorRecord = visitors.records?.first, let summary = visitorRecord.summary {
			   Text("(\(summary))")
				  .font(.system(size: 7))
				  .foregroundColor(.gray)
			}

			if let homeRecord = home.records?.first, let summary = homeRecord.summary {
			   Text("(\(summary))")
				  .font(.system(size: 7))
				  .foregroundColor(.gray)
			}

		 }

		 Text("vs.")
			.font(.footnote)
			.foregroundColor(.white)
			.frame(width: UIScreen.main.bounds.width * 0.06)

		 VStack {
			Text(home.team?.displayName ?? "not determined")
			   .font(.title3)
			   .lineLimit(2)
			   .minimumScaleFactor(0.5)
			   .frame(maxWidth: .infinity, alignment: .center)
			   .frame(width: UIScreen.main.bounds.width * 0.35)
			   .multilineTextAlignment(.center)
			   .padding(.trailing)
			if let visitorRecord = visitors.records?.first, let summary = visitorRecord.summary {
			   Text("(\(summary))")
				  .font(.system(size: 7))
				  .foregroundColor(.gray)
			}

			if let homeRecord = home.records?.first, let summary = homeRecord.summary {
			   Text("(\(summary))")
				  .font(.system(size: 7))
				  .foregroundColor(.gray)
			}

		 }
	  }
	  .padding(.bottom, 4)
	  .shadow(radius: 4)
	  .frame(maxWidth: .infinity, alignment: .center)
	  .background(LinearGradient(gradient: Gradient(colors: [.gpBlueLight, .gpBlueDark]),
								 startPoint: .top,
								 endPoint: .bottom))
	  .cornerRadius(10)
	  .foregroundColor(.gpWhite)
   }
}

// Preview
//#Preview {
//   MatchupHeaderView(visitors: Competitor(id: "team1", abbrev: "NYM", displayName: "New York Mets", shortDisplayName: "Mets", logo: "logo_url", isHome: false, score: 5, probable: nil, record: Record(summary: nil, wins: 45, losses: 35)),
//					 home: Competitor(id: "team2", abbrev: "NYY", displayName: "New York Yankees", shortDisplayName: "Yankees", logo: "logo_url", isHome: true, score: 7, probable: nil, record: Record(summary: nil, wins: 50, losses: 30)))
//}
