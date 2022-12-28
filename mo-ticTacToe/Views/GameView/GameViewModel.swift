//
//  GameViewModel.swift
//  mo-ticTacToe
//
//  Created by Игорь Чернышов on 28.12.2022.
//

import SwiftUI

final class GameViewModel: ObservableObject {
	@AppStorage("user") private var userData: Data?

	let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

	@Published var game = Game(id: UUID().uuidString,
							   player1Id: "player1",
							   player2Id: "player2",
							   blockMoveForPlayerId: "Player 2",
							   winningPlayerId: "",
							   rematchPlayerId: [],
							   moves: Array(repeating: nil, count: 9))

	@Published var currentUser: User!

	private let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,4,8], [2,4,6], [0,3,6], [1,4,7], [2,5,8]]

	init() {
		retrieveUser()
		if currentUser == nil {
			saveUser()
		}
		print("Loaded user with id", currentUser.id)
	}

	func processPlayerMove(for position: Int) {
		if isSquareOccupied(in: game.moves, forIndex: position) { return }
		game.moves[position] = Move(isPlayer1: true, boardIndex: position)
		game.blockMoveForPlayerId = "player2"

		if checkForWinCondition(for: true, in: game.moves) {
			print("You have won!")
			return
		}

		if checkForDrawCondition(in: game.moves) {
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
