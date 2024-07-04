import SwiftUI

struct TeamScheduleView: View {
   @ObservedObject var vm = ScheduleViewModel.shared

   var body: some View {
	  NavigationView {
		 VStack {
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

			if vm.filteredEvents.isEmpty {
			   ProgressView()
			} else {
			   List(vm.filteredEvents, id: \.id) { event in
				  MatchupView(event: event)
					 .environmentObject(vm)
			   }
			   .padding(.top, -18)
			}
		 }
		 .onAppear {
			let today = Date()
			vm.selectedDate = vm.dateFormatter.string(from: today)
			vm.loadSchedule(for: today)
		 }
		 .preferredColorScheme(.dark)
	  }
   }
}

// Preview
#Preview {
   TeamScheduleView()
}
