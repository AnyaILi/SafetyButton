//
//  FirebaseManager.swift
//  SafetyButton
//
//  Created by Anya Li on 4/15/24.
//

import Foundation
import Firebase
class FirebaseManager : NSObject {
    let auth: Auth
    let firestore: Firestore
    static let shared = FirebaseManager()
    override init(){
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
