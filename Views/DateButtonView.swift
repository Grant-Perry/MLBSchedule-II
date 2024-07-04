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
   @ObservedObject var vm = ScheduleViewModel.shared

   var body: some View {
	  HStack {
		 ForEach(0..<7, id: \.self) { day in
			Button(action: {
			   let newSelectedDate = Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()
			   vm.selectedDate = vm.dateFormatter.string(from: newSelectedDate)
			   vm.loadSchedule(for: newSelectedDate)
			}) {
			   Text(vm.formattedDateButton(for: day))
				  .frame(width: 50)
				  .padding()
				  .background(vm.selectedDate == vm.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()) ? Color.gpBlueLight : Color.clear)
				  .foregroundColor(vm.selectedDate == vm.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()) ? .gpWhite : .gray)
				  .cornerRadius(8)
				  .multilineTextAlignment(.center)
			}
//			.background(LinearGradient(gradient: Gradient(colors: [.gpBlueLight, .gpBlueDark]),
//									   startPoint: .top,
//									   endPoint: .bottom))
			.font(vm.selectedDate == vm.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()) ? .system(size: 14) : .system(size: 12))
//			.opacity(0.5)
			.opacity(vm.selectedDate == vm.dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()) ? 1.0 : 0.5 )
			.cornerRadius(10.0)
		 }
	  }
   }
}

#Preview {
   DateButtonView()
}
