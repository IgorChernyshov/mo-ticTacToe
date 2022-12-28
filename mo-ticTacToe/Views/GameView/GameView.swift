//
//  GameView.swift
//  mo-ticTacToe
//
//  Created by Игорь Чернышов on 27.12.2022.
//

import SwiftUI

struct GameView: View {

	@ObservedObject var viewModel: GameViewModel
	@Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
		GeometryReader { geometry in
			VStack {
				Text("Waiting for the player")

				Button {
					mode.wrappedValue.dismiss()
				} label: {
					GameButton(title: "Quit", backgroundColor: Color(.systemRed))
				}

				LoadingView()

				Spacer()

				VStack {
					LazyVGrid(columns: viewModel.columns, spacing: 5) {
						ForEach(0..<9) { index in
							ZStack {
								GameSquareView(proxy: geometry)
								PlayerIndicatorView(systemImageName: viewModel.game.moves[index]?.indicator ?? "applelogo")
							}
							.onTapGesture {
								viewModel.processPlayerMove(for: index)
							}
						}
					}
				}
			}
		}
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel())
    }
}
