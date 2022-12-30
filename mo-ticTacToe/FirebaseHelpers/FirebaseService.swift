//
//  FirebaseService.swift
//  mo-ticTacToe
//
//  Created by Игорь Чернышов on 30.12.2022.
//

import Combine
import Firebase
import FirebaseFirestoreSwift

final class FirebaseService: ObservableObject {

	@Published var game: Game!

	static let shared = FirebaseService()

	init() {}

	func createOnlineGame() {
		do {
			try FirebaseReference(.Game)
				.document(game.id)
				.setData(from: game)
		} catch {
			print("Error creating online game", error.localizedDescription)
		}
	}

	func startGame(with userId: String) {
		FirebaseReference(.Game)
			.whereField("player2Id", isEqualTo: "")
			.whereField("player1Id", isNotEqualTo: userId)
			.getDocuments { [weak self] querySnapshot, error in
				guard let self = self else {
					print("Error - self deallocated")
					return
				}

				if let error = error {
					print("Error starting game", error.localizedDescription)
					self.createNewGame(with: userId)
					return
				}

				// Try to join game
				if let gameData = querySnapshot?.documents.first {
					self.game = try? gameData.data(as: Game.self)
					self.game.player2Id = userId
					self.game.blockMoveForPlayerId = userId

					self.updateGame(self.game)
					self.listenForGameChanges()
					return
				}

				// Try to create a new game
				self.createNewGame(with: userId)
			}
	}

	func listenForGameChanges() {
		FirebaseReference(.Game)
			.document(game.id)
			.addSnapshotListener { [weak self] documentSnapshot, error in
				print("Changes received from Firebase")
				if let error = error {
					print("Error listening to changes", error.localizedDescription)
					return
				}

				if let snapshot = documentSnapshot {
					self?.game = try? snapshot.data(as: Game.self)
				}
			}
	}

	func createNewGame(with userId: String) {
		print("Creating new game for userId", userId)
		game = Game(id: UUID().uuidString,
						 player1Id: userId,
						 player2Id: "",
						 blockMoveForPlayerId: userId,
						 winningPlayerId: "",
						 rematchPlayerId: [],
						 moves: Array(repeating: nil, count: 9))
		createOnlineGame()
		listenForGameChanges()
	}

	func updateGame(_ game: Game) {
		do {
			try FirebaseReference(.Game)
				.document(game.id)
				.setData(from: game)
		} catch {
			print("Error updating online game", error.localizedDescription)
		}
	}

	func quitGame() {
		guard game != nil else { return }
		FirebaseReference(.Game).document(game.id).delete()
	}
}
