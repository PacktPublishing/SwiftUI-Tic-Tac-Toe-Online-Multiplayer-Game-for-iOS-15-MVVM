//
//  FirebaseReference.swift
//  FirebaseReference
//
//  Created by David Kababyan on 18/08/2021.
//

import Firebase

enum FCollectionReference: String {
    case Game
}


func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
