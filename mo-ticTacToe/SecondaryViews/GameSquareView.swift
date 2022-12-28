//
//  GameSquareView.swift
//  mo-ticTacToe
//
//  Created by Игорь Чернышов on 28.12.2022.
//

import SwiftUI

struct GameSquareView: View {

	var proxy: GeometryProxy

    var body: some View {
		Circle()
			.foregroundColor(.blue.opacity(0.7))
			.frame(width: proxy.size.width / 3 - 15, height: proxy.size.width / 3 - 15)
    }
}
