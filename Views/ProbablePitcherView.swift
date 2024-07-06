
import SwiftUI

struct ProbablePitcherView: View {
   var name: String
   var era: String?
   var href: String

   var body: some View {
	  VStack {
		 if let url = URL(string: href) {
			Link(destination: url) {
			   Text("\(name)")
				  .font(.system(size: 11))
				  .frame(maxWidth: .infinity)
				  .multilineTextAlignment(.center)
				  .padding(.top, 3)
			}
		 }
		 Text("ERA: \(era ?? "N/A")")
			.font(.system(size: 10))
			.frame(maxWidth: .infinity)
			.multilineTextAlignment(.center)
	  }
   }
}
