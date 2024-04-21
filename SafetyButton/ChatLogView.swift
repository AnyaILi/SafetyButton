//
//  ChatLogView.swift
//  SafetyButton
//
//  Created by Anya Li on 4/19/24.
//

import SwiftUI
import Firebase

struct FirebaseConstant {
    static let uid = "uid"
    static let fromID = "fromID"
    static let toID = "toID"
    static let text = "text"
    static let email = "email"
}
struct ChatMessage: Identifiable{
    
    var id: String { documentID }
    let documentID: String
    let fromID, toID, text: String
    
    init(documentID: String, data: [String: Any]) {
        self.documentID = documentID
        self.fromID = data[FirebaseConstant.fromID] as? String ?? ""
        self.toID = data[FirebaseConstant.toID] as? String ?? ""
        self.text = data[FirebaseConstant.text] as? String ?? ""
    }
}
class ChatLogViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var chatText = ""
    
    @Published var chatMessages = [ChatMessage]()
    
    var chatUser: ChatUser?
    init(chatUser: ChatUser?){
        self.chatUser = chatUser
        fetchMessages()
    }
    var firestoreListener: ListenerRegistration?
    func fetchMessages() {
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toID = chatUser?.uid else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromID)
            .collection(toID)
            .order(by: "timestamp")
            .addSnapshotListener {QuerySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for message: \(error)"
                    print(error)
                    return
                }
                QuerySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added{
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentID: change.document.documentID, data: data))
                        print("Appending chatMessage in ChatLogView")
                    }
                })
                DispatchQueue.main.async{
                    self.count+=1
                }

//                QuerySnapshot?.documents.forEach({QueryDocumentSnapshot in
//                    let data = QueryDocumentSnapshot.data()
//                    let docID = QueryDocumentSnapshot.documentID
//                    let chatMessage = ChatMessage(documentID: docID, data: data)
//                    self.chatMessages.append(chatMessage)
//                })
            }
    }
    func handleAutoSend(){
        print(chatText)
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let toID = "4QZzsAwrIvMXCNCCvBIKP0fHVTX2"

        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(fromID)
            .collection(toID)
            .document()
        let messageData = [FirebaseConstant.fromID: fromID, FirebaseConstant.toID: toID, FirebaseConstant.text: "Help I'm in a dangerous situation. If I don't respond to your messages send help", "timestamp": Timestamp()] as [String : Any]
        document.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into firestore: \(error)"
                return
            }
            print("Successful User")
            self.persistAutoRecentMessage()
            self.chatText=""
            self.count+=1

        }
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toID)
            .collection(fromID)
            .document()
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into firestore: \(error)"
                return
            }
            print("Successful Recipient")
            self.chatText = ""
            self.count+=1

        }

    }

    func handleSend(){
        print(chatText)
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toID = chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(fromID)
            .collection(toID)
            .document()
        let messageData = [FirebaseConstant.fromID: fromID, FirebaseConstant.toID: toID, FirebaseConstant.text: self.chatText, "timestamp": Timestamp()] as [String : Any]
        document.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into firestore: \(error)"
                return
            }
            print("Successful User")
            self.persistRecentMessage()
            self.chatText=""
            self.count+=1

        }
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toID)
            .collection(fromID)
            .document()
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into firestore: \(error)"
                return
            }
            print("Successful Recipient")
            self.chatText = ""
            self.count+=1

        }

    }
    private func persistAutoRecentMessage(){
        print("enter")
//        guard let chatUser = chatUser else { return }
//        print(chatUser)
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        print(uid)
        let toID = "4QZzsAwrIvMXCNCCvBIKP0fHVTX2"
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document("4QZzsAwrIvMXCNCCvBIKP0fHVTX2")
        
        let data = [
            "timestamp" : Timestamp(),
            "text": "Help I'm in a dangerous situation. If I don't respond to your messages send help",
            FirebaseConstant.fromID: uid,
            FirebaseConstant.toID: "4QZzsAwrIvMXCNCCvBIKP0fHVTX2",
            FirebaseConstant.email: "tempstore@gmail.com"
        ] as [String : Any]
        
        let recipientData = [
            "timestamp" : Timestamp(),
            "text": "Help I'm in a dangerous situation. If I don't respond to your messages send help",
            FirebaseConstant.fromID: "4QZzsAwrIvMXCNCCvBIKP0fHVTX2",
            FirebaseConstant.toID: uid,
//            FirebaseConstant.email: chatUser.email
        ] as [String : Any]
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                return
            }
        }
//        document.setData(recipientData) { error in
//            if let error = error {
//                self.errorMessage = "Failed to save recent message: \(error)"
//                return
//            }
//        }
    }

    private func persistRecentMessage(){
        guard let chatUser = chatUser else { return }
        print(chatUser)
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        print(uid)
        guard let toID = self.chatUser?.uid else { return }
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toID)
        
        let data = [
            "timestamp" : Timestamp(),
            "text": self.chatText,
            FirebaseConstant.fromID: uid,
            FirebaseConstant.toID: toID,
            FirebaseConstant.email: chatUser.email
        ] as [String : Any]
        
        let recipientData = [
            "timestamp" : Timestamp(),
            "text": self.chatText,
            FirebaseConstant.fromID: toID,
            FirebaseConstant.toID: uid,
//            FirebaseConstant.email: chatUser.email
        ] as [String : Any]
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                return
            }
        }
//        document.setData(recipientData) { error in
//            if let error = error {
//                self.errorMessage = "Failed to save recent message: \(error)"
//                return
//            }
//        }
    }

    @Published var count = 0
}

struct ChatLogView: View {
//    let chatUser: ChatUser?
//
//    
//    init(chatUser: ChatUser?){
//        self.chatUser = chatUser
//        self.vm = .init(chatUser: chatUser)
//    }
//    @State var placeholderString = "Message"
    @ObservedObject var vm: ChatLogViewModel
    var body: some View {
        ZStack{
            VStack{
                ScrollView {
                    ScrollViewReader { ScrollViewProxy in
                        ForEach(vm.chatMessages) { message in
                            VStack{
                                if message.fromID == FirebaseManager.shared.auth.currentUser?.uid {
                                    HStack{
                                        Spacer()
                                        HStack{
                                            Text(message.text)
                                                .foregroundColor(.white)
                                            
                                        }
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                    }
                                    
                                }
                                else{
                                    HStack{
                                        HStack{
                                            Text(message.text)
                                                .foregroundColor(.black)
                                            
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        Spacer()
                                        
                                    }
                                    
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                        }
                        HStack{ Spacer() }
                            .id("Empty")
                        .onReceive(vm.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                ScrollViewProxy.scrollTo("Empty", anchor: .bottom)
                            }
                    }
                    
                    }
                    
                    
                }
                .background(Color(hex: "FFEBEB"))
                HStack{
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 24))
                        .foregroundColor(Color(.darkGray))
                    ZStack(alignment: .leading){
                        if vm.chatText.isEmpty {
                            VStack{
                                Text("Message")
                                    .padding(.leading, 2)
                                    .padding(.top, 10)
                                    .multilineTextAlignment(.leading)
                                    .opacity(0.4)
                                Spacer(minLength: 0)
                            }
                        }
                        TextEditor(text: $vm.chatText)
                            .opacity(vm.chatText.isEmpty ? 0.1 : 1)
                            
                    }
                    .frame(height: 40)
                    Button {
                        vm.handleSend()
                    } label: {
                        Text("Send")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(4)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
        .navigationTitle(vm.chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear{
                vm.firestoreListener?.remove()
            }
//            .navigationBarItems(trailing: Button(action: {
//                vm.count += 1
//            }, label:{
//                Text("Count: \(vm.count)")
//            }))
    }
}
#Preview {
    NavigationView{
//        ChatLogView(chatUser: .init(data: ["uid": "d3Y4lcDEzegQi6A9UaFFZRva76l2", "email": "anyali@gmail.com"]))
        Messages(scrums: .constant(DailyScrum.sampleData))
    }
}
