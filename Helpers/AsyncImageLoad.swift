//   AsyncImageLoad.swift
//   MLBSchedule
//
//   Created by: Grant Perry on 6/25/24 at 5:22 PM
//     Modified: 
//
//  Copyright © 2024 Delicious Studios, LLC. - Grant Perry
//

import SwiftUI

struct asyncImageLoad: View {
   let teamName: URL

   var body: some View {
	  AsyncImage(url: teamName) { image in
		 image.resizable()
			.scaledToFit()
			.frame(width: 70)
			.background(Color.clear)
			.clipShape(Circle())
			.overlay(Circle().stroke(Color.gray, lineWidth: 1))
	  } placeholder: {
		 ProgressView()
	  }
   }
}
