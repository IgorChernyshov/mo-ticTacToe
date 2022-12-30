//
//  GameViewModel.swift
//  mo-ticTacToe
//
//  Created by Игорь Чернышов on 28.12.2022.
//

import Combine
import SwiftUI

final class GameViewModel: ObservableObject {
	@AppStorage("user") private var userData: Data?

	let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

	@Published var game: Game? {
		didSet {
			checkIsGameOver()

			guard let game = game else {
				updateGameNotifications(for: .finished)
				return
			}

			game.player2Id.isEmpty ? updateGameNotifications(for: .waitingForPlayer) : updateGameNotifications(for: .started)
		}
	}

	@Published var gameNotification = GameNotification.waitingForPlayer
	@Published var currentUser: User!
	@Published var alertItem: AlertItem?

	private var cancellables: Set<AnyCancellable> = []

	private let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,4,8], [2,4,6], [0,3,6], [1,4,7], [2,5,8]]

	init() {
		retrieveUser()
		if currentUser == nil {
			saveUser()
		}
		print("Loaded user with id", currentUser.id)
	}

	func getTheGame() {
		FirebaseService.shared.startGame(with: currentUser.id)
		FirebaseService.shared.$game
			.assign(to: \.game, on: self)
			.store(in: &cancellables)
	}

	func processPlayerMove(for position: Int) {
		guard game != nil else { return }

		if isSquareOccupied(in: game!.moves, forIndex: position) { return }
		game!.moves[position] = Move(isPlayer1: isPlayer1(), boardIndex: position)
		game!.blockMoveForPlayerId = currentUser.id

		FirebaseService.shared.updateGame(game!)

		if checkForWinCondition(for: isPlayer1(), in: game!.moves) {
			game!.winningPlayerId = currentUser.id
			FirebaseService.shared.updateGame(game!)
			print("You have won!")
			return
		}

		if checkForDrawCondition(in: game!.moves) {
			game!.winningPlayerId = "0"
			FirebaseService.shared.updateGame(game!)
			print("Draw!")
			return
		}
	}

	func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
		moves.contains { $0?.boardIndex == index }
	}

	func checkForWinCondition(for player1: Bool, in moves: [Move?]) -> Bool {
		let playerMoves = moves.compactMap { $0 }.filter { $0.isPlayer1 == player1 }
		let playerPositions = Set(playerMoves.map { $0.boardIndex })
		for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
		return false
	}

	func checkForDrawCondition(in moves: [Move?]) -> Bool {
		moves.compactMap { $0 }.count == 9
	}

	func quitGame() {
		FirebaseService.shared.quitGame()
	}

	func checkForGameBoardStatus() -> Bool {
		game != nil ? game!.blockMoveForPlayerId == currentUser.id : false
	}

	func isPlayer1() -> Bool {
		guard let game = game else {
			return false
		}
		return game.player1Id == currentUser.id
	}

	func checkIsGameOver() {
		alertItem = nil

		guard let game = game else { return }

		if game.winningPlayerId == "0" {
			alertItem = AlertContext.draw
		}

		if !game.winningPlayerId.isEmpty {
			if game.winningPlayerId == currentUser.id {
				alertItem = AlertContext.youWin
			} else {
				alertItem = AlertContext.youLost
			}
		}
	}

	func resetGame() {
		guard game != nil else {
			alertItem = AlertContext.quit
			return
		}

		let rematchPlayerIdCount = game!.rematchPlayerId.count
		if rematchPlayerIdCount == 1 {
			// Start new game
			game!.moves = Array(repeating: nil, count: 9)
			game!.winningPlayerId = ""
			game!.blockMoveForPlayerId = game!.player2Id
		} else if rematchPlayerIdCount == 2 {
			game!.rematchPlayerId = []
		}
		game!.rematchPlayerId.append(currentUser.id)
		FirebaseService.shared.updateGame(game!)
	}

	func updateGameNotifications(for state: GameState) {
		switch state {
		case .started:
			gameNotification = GameNotification.gameHasStarted
		case .waitingForPlayer:
			gameNotification = GameNotification.waitingForPlayer
		case .finished:
			gameNotification = GameNotification.gameFinished
		}
	}

	// MARK: - User Object
	func saveUser() {
		currentUser = User()
		do {
			print("Saving user")
			userData = try JSONEncoder().encode(currentUser)
		} catch {
			print("Couldn't save user")
		}
	}

	func retrieveUser() {
		guard let userData = userData else { return }
		do {
			print("Decoding user")
			currentUser = try JSONDecoder().decode(User.self, from: userData)
		} catch {
			print("No saved user data")
		}
	}
}
