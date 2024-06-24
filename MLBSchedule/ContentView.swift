import SwiftUI

struct ContentView: View {
//   @StateObject private var viewModel = MLBTeamSchedulesViewModel()

   var body: some View {
	  Text("HI")
   }
//	  VStack {
//		 if viewModel.teams.isEmpty {
//			Text("Loading...")
//			   .onAppear {
//				  viewModel.fetchMLBTeamSchedules()
//			   }
//		 } else {
//			List {
//			   ForEach(viewModel.teams.keys.sorted(), id: \.self) { team in
//				  Section(header: Text(team)) {
//					 ForEach(viewModel.teams[team]?.keys.sorted() ?? [], id: \.self) { date in
//						if let details = viewModel.teams[team]?[date] {
//						   VStack(alignment: .leading) {
//							  Text("Date: \(date)")
//							  Text(details)
//						   }
//						}
//					 }
//				  }
//			   }
//			}
//		 }
//	  }
//	  .padding()
//   }
}

#Preview {
   ContentView()
}
