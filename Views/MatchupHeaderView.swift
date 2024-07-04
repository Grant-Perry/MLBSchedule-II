import SwiftUI

struct MatchupHeaderView: View {
   var visitors: String
   var home: String

   var body: some View {
	  HStack {
		 Text(visitors)
			.font(.title3)
			.lineLimit(2)
			.minimumScaleFactor(0.5)
			.frame(maxWidth: .infinity, alignment: .center) // Centered text
			.frame(width: UIScreen.main.bounds.width * 0.35)
			.multilineTextAlignment(.center)
			.padding(.leading)

		 Text("vs.")
			.font(.footnote)
			.foregroundColor(.white)
			.frame(width: UIScreen.main.bounds.width * 0.06)

		 Text(home)
			.font(.title3)
			.lineLimit(2)
			.minimumScaleFactor(0.5)
			.frame(maxWidth: .infinity, alignment: .center) // Centered text
			.frame(width: UIScreen.main.bounds.width * 0.35)
			.multilineTextAlignment(.center)
			.padding(.trailing)

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
#Preview {
   MatchupHeaderView(visitors: "New York Mets", home: "New York Yankees")
}
