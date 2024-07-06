import SwiftUI

struct TeamScheduleView: View {
   @ObservedObject var vm = ScheduleViewModel.shared
   @State private var selectedDate = Date()
   let weekFromNow = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
   let weekBeforeNow = Calendar.current.date(byAdding: .day, value: -7, to: Date())!

   var body: some View {
	  NavigationView {
		 VStack {
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
			   .frame(maxWidth: 150)
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
			.padding(.top, 8)
			.padding(.bottom, 8)

			if vm.filteredEvents.isEmpty {
			   ProgressView()
			} else {
			   HStack {
				  Text(vm.headerDateFormatter.string(from: vm.dateFormatter.date(from: vm.selectedDate) ?? Date()))
					 .font(.title3)
					 .padding(.leading)
				  Spacer()
			   }
			   .padding(.top, -10)

			   List(vm.filteredEvents, id: \.id) { event in
				  MatchupView(event: event)
					 .environmentObject(vm)
			   }
			   .padding(.top, -14)
			   .background(.clear)
			}
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
