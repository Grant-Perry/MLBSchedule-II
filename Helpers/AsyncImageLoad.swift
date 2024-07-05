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
