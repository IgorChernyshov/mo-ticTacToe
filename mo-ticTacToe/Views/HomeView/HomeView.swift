//
//  HomeView.swift
//  mo-ticTacToe
//
//  Created by Игорь Чернышов on 27.12.2022.
//

import SwiftUI

struct HomeView: View {

	@StateObject var viewModel = HomeViewModel()

    var body: some View {
		VStack {
			Button {
				viewModel.isGameViewPresented = true
			} label: {
				GameButton(title: "Play", backgroundColor: Color(.systemGreen))
			}
		}
		.fullScreenCover(isPresented: $viewModel.isGameViewPresented) {
			GameView(viewModel: GameViewModel())
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
