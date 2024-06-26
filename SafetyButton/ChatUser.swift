//
//  ChatUser.swift
//  SafetyButton
//
//  Created by Anya Li on 4/15/24.
//

import Foundation
struct ChatUser: Identifiable {
    
    var id: String { uid }
    let uid, email: String
    init(data: [String: Any]){
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
    }
}
