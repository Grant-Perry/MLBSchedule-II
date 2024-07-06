import SwiftUI

struct TeamScheduleView: View {
   @ObservedObject var vm = ScheduleViewModel.shared
   @State private var selectedDate = Date()
   let weekFromNow = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
   let weekBeforeNow = Calendar.current.date(byAdding: .day, value: -7, to: Date())!

   var body: some View {
	  NavigationView {
		 VStack(spacing: 0) {
			// Header with Calendar Icon and Date Picker
			HStack {
			   Spacer()

			   DatePicker(
				  "",
				  selection: Binding(
					 get: { selectedDate },
					 set: { newValue in
						selectedDate = newValue
						vm.selectedDate = vm.dateFormatter.string(from: newValue)
						vm.loadSchedule(for: newValue)
					 }
				  ),
				  in: weekBeforeNow...weekFromNow,
				  displayedComponents: [.date]
			   )
			   .datePickerStyle(CompactDatePickerStyle())
			   .labelsHidden()
			   .frame(maxWidth: 115)
			   .id(selectedDate) // Ensure DatePicker updates when the date changes

			   Image(systemName: "calendar")
				  .padding(.trailing)
				  .overlay {
					 DatePicker(
						"",
						selection: Binding(
						   get: { selectedDate },
						   set: { newValue in
							  selectedDate = newValue
							  vm.selectedDate = vm.dateFormatter.string(from: newValue)
							  vm.loadSchedule(for: newValue)
						   }
						),
						displayedComponents: [.date]
					 )
					 .blendMode(.destinationOver)
				  }
			}
			.padding(.horizontal)

			if vm.filteredEvents.isEmpty {
			   ProgressView()
			} else {
			   HStack {
				  Text(vm.headerDateFormatter.string(from: vm.dateFormatter.date(from: vm.selectedDate) ?? Date()))
					 .font(.system(size: 18))
					 .padding(.leading)
					 .frame(maxWidth: .infinity, alignment: .leading)
			   }
			   .padding(.vertical, 8) // Add vertical padding to the HStack

			   List(vm.filteredEvents, id: \.id) { event in
				  MatchupView(event: event)
					 .environmentObject(vm)
			   }
			   .listStyle(PlainListStyle()) // Ensure the list style does not add extra padding
			}

			Spacer()

			VStack(alignment: .center, spacing: 0) {
			   Text("Version: \(vm.getAppVersion())")
				  .font(.system(size: 10))
				  .padding(.bottom, 10)
				  .padding(.top, 10)
			}
			.frame(maxWidth: .infinity)
			.background(Color.clear)
			.padding(.bottom, 20) // Adjust padding as necessary
		 }
		 .onAppear {
			let today = Date()
			selectedDate = today
			vm.selectedDate = vm.dateFormatter.string(from: today)
			vm.loadSchedule(for: today)
		 }
		 .preferredColorScheme(.dark)
		 .navigationBarTitle("MLB Schedule", displayMode: .inline)
	  }
   }
}

// Preview
#Preview {
   TeamScheduleView()
}
