//
//  mo_ticTacToeApp.swift
//  mo-ticTacToe
//
//  Created by Игорь Чернышов on 27.12.2022.
//

import SwiftUI
import Firebase

@main
struct mo_ticTacToeApp: App {

	init() {
		FirebaseApp.configure()
	}

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
