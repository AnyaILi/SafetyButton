//
//  ChatLogView.swift
//  SafetyButton
//
//  Created by Anya Li on 4/19/24.
//

import SwiftUI

struct ChatLogView: View {
    let chatUser: ChatUser?
    var body: some View {
        ScrollView {
            ForEach(0..<10) { num in
                HStack{
                    Spacer()
                    HStack{
                        Text("FAKE MESSAGE")
                            .foregroundColor(.white)
                        
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            HStack{ Spacer() }
        }
        .background(Color(hex: "FFEBEB"))
        .navigationTitle(chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView{
        ChatLogView(chatUser: .init(data: ["uid": "d3Y4lcDEzegQi6A9UaFFZRva76l2", "email": "anyali@gmail.com"]))
    }
}
