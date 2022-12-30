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
				Text(viewModel.gameNotification)

				Button {
					mode.wrappedValue.dismiss()
					viewModel.quitGame()
				} label: {
					GameButton(title: "Quit", backgroundColor: Color(.systemRed))
				}

				if viewModel.game?.player2Id == "" {
					LoadingView()
				}

				Spacer()

				VStack {
					LazyVGrid(columns: viewModel.columns, spacing: 5) {
						ForEach(0..<9) { index in
							ZStack {
								GameSquareView(proxy: geometry)
								PlayerIndicatorView(systemImageName: viewModel.game?.moves[index]?.indicator ?? "applelogo")
							}
							.onTapGesture {
								viewModel.processPlayerMove(for: index)
							}
						}
					}
				}
				.disabled(viewModel.checkForGameBoardStatus())
				.padding()
				.alert(item: $viewModel.alertItem) { alertItem in
					alertItem.isForQuit ?
					Alert(title: alertItem.title,
						  message: alertItem.message,
						  dismissButton: .destructive(alertItem.buttonTitle,
						  action: {
						mode.wrappedValue.dismiss()
						viewModel.quitGame()
					})) :
					Alert(title: alertItem.title,
						  message: alertItem.message,
						  primaryButton: .default(alertItem.buttonTitle,
						  action: {
						viewModel.resetGame()
					}), secondaryButton: .destructive(Text("Quit"), action: {
						mode.wrappedValue.dismiss()
						viewModel.quitGame()
					}))

				}
			}
		}.onAppear {
			viewModel.getTheGame()
		}
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel())
    }
}
