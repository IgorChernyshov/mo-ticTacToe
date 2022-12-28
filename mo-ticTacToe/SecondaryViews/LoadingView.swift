//
//  LoadingView.swift
//  mo-ticTacToe
//
//  Created by Игорь Чернышов on 28.12.2022.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
		ZStack {
			Color(.systemBackground)
				.edgesIgnoringSafeArea(.all)

			ProgressView()
				.progressViewStyle(CircularProgressViewStyle())
				.scaleEffect(2)
		}
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
