//   DateButtonView.swift
//   MLBSchedule
//
//   Created by: Grant Perry on 6/25/24 at 1:30 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI
let vm = ScheduleViewModel.shared

struct DateButtonView: View {
   var body: some View {
	  HStack {
		 ForEach(0..<7, id: \.self) { day in
			Button(action: {
			   let newSelectedDate = Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()
			   vm.selectedDate = vm.dateFormatter.string(from: newSelectedDate)
			   vm.loadSchedule(for: newSelectedDate)
			}) {
			   Text(vm.formattedDateButton(for: day))
				  .frame(width: 70)
				  .padding()
				  .background(vm.selectedDate == vm.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: day,
																							   to: Date()) ?? Date()) ? Color.blue : Color.clear)
				  .foregroundColor(vm.selectedDate == vm.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()) ? .white : .black)
				  .cornerRadius(8)
				  .multilineTextAlignment(.center)
			}
			.background(.blue.gradient)
			.opacity(0.5)
			.cornerRadius(10.0)
		 }
	  }
   }
}

#Preview {
    DateButtonView()
}
