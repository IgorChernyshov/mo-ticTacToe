//
//  FirebaseReference.swift
//  mo-ticTacToe
//
//  Created by Игорь Чернышов on 30.12.2022.
//

import Firebase

enum FCollectionReference: String {
	case Game
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
	Firestore.firestore().collection(collectionReference.rawValue)
}
