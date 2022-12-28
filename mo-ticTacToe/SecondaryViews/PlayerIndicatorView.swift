//
//  PlayerIndicatorView.swift
//  mo-ticTacToe
//
//  Created by Игорь Чернышов on 28.12.2022.
//

import SwiftUI

struct PlayerIndicatorView: View {

	var systemImageName: String

	var body: some View {
		Image(systemName: systemImageName)
			.resizable()
			.frame(width: 40, height: 40)
			.foregroundColor(.white)
			.opacity(systemImageName == "applelogo" ? 0 : 1)
	}
}

struct PlayerIndicatorView_Previews: PreviewProvider {
	static var previews: some View {
		PlayerIndicatorView(systemImageName: "applelogo")
	}
}
