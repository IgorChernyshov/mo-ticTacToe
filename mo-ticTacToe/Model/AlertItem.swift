//
//  AlertItem.swift
//  mo-ticTacToe
//
//  Created by Игорь Чернышов on 30.12.2022.
//

import SwiftUI

struct AlertItem: Identifiable {
	let id: UUID
	let isForQuit: Bool
	let title: Text
	let message: Text
	let buttonTitle: Text

	init(id: UUID = UUID(), isForQuit: Bool = false, title: Text, message: Text, buttonTitle: Text) {
		self.id = id
		self.isForQuit = isForQuit
		self.title = title
		self.message = message
		self.buttonTitle = buttonTitle
	}
}

enum AlertContext {
	static let youWin = AlertItem(title: Text("You win"), message: Text("You are good at this game"), buttonTitle: Text("Rematch"))
	static let youLost = AlertItem(title: Text("You lost"), message: Text("Try rematch"), buttonTitle: Text("Rematch"))
	static let draw = AlertItem(title: Text("Draw"), message: Text("That was a cool game"), buttonTitle: Text("Rematch"))
	static let quit = AlertItem(isForQuit: true, title: Text("Game Over"), message: Text("Other player left"), buttonTitle: Text("Quit"))
}
