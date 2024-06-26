//
//  MainView.swift
//  SafetyButton
//
//  Created by Anya Li on 4/15/24.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let text, email: String
    let fromID, toID: String
    let timestamp: Date
    
    var username: String {
        email.components(separatedBy: "@").first ?? email
    }
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    
}

class MessagesModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var isUserCurrentlyLoggedOut = false
    
    init() {
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
        
        fetchRecentMessages()
    }

    @Published var recentMessages = [RecentMessage]()
    
    private var listener: ListenerRegistration?
    
    func fetchRecentMessages(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
//        listener?.remove()

        self.recentMessages.removeAll()
        
        
        /*listener = */FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { QuerySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                QuerySnapshot?.documentChanges.forEach({ change in
                    let docID = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docID
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    do{
                        if let rm = try? change.document.data(as: RecentMessage.self){
                            //                    self.recentMessages.insert(.init(documentID: docID, data: change.document.data()), at: 0)
                            //                    }
                            self.recentMessages.insert(rm, at: 0)
                        }
                    } catch {
                        print(error)
                    }
                })
                
            }
    }
    func fetchCurrentUser(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return }
        self.errorMessage = "\(uid)"
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
            }
//            print(data)
//            self.errorMessage = "Data: \(data.description)"
            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            self.chatUser = ChatUser(data: data)
//            self.errorMessage = chatUser.email
        }
    }
    func handleSignOut(){
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}

struct Messages: View {
    @State var shouldShowLogOutOptions = false
    @ObservedObject private var vm = MessagesModel()
    @Binding var scrums: [DailyScrum]
    @State private var isPresentingNewScrumView = false
    @State var shouldShowNewMessageScreen = false
    @State var shouldNavigateToChatLogView = false
    
    var chatLogViewModel = ChatLogViewModel(chatUser: nil)

    var body: some View {
        NavigationView{
            ZStack{
                Color(hex: "FFEBEB")
                    .ignoresSafeArea()
                VStack{
                    

                    //                Text("User: \(vm.errorMessage/*chatUser?.uid ?? ""*/)")
                    //                Spacer()
                    HStack (spacing: 16){
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipped()
                            .cornerRadius(50)
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                .stroke(Color(.label), lineWidth: 1))
                            .shadow(radius:5)
                        //                        .font(.system(size: 24, weight: .heavy))
                        let email = vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
                        Text(email)
                            .font(.system(size: 24, weight: .bold))
                        Spacer()
                        Button{
                            shouldShowLogOutOptions.toggle()
                        } label: {
                            Image(systemName: "gear")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(Color(.label))
                        }
                        
                    }
                    .padding()
                    .actionSheet(isPresented: $shouldShowLogOutOptions) {
                        .init(title: Text("Settings"), message: Text("what do you want to do?"), buttons: [
                            .destructive(Text("Sign Out"), action: {
                                print("handle sign out")
                                vm.handleSignOut()
                            }),
                            .cancel()
                            //                        .destructive(Text("Sign Out"), action: {
                            //                            print("handle sign out")
                        ])
                        //                        .cancel()
                    }
                    .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
                        LoginView(didCompleteLoginProcess: {
                            self.vm.isUserCurrentlyLoggedOut = false
                            self.vm.fetchCurrentUser()
                            self.vm.fetchRecentMessages()
                        })
                    }
                    Divider()
                    ZStack{
                        ScrollView{
                            Button {
                                shouldShowNewMessageScreen.toggle()
                            } label: {
                                HStack{
                                    Spacer()
                                    Text("+ New Message")
                                        .font(.system(size: 16, weight: .bold))
                                    Spacer()
                                }
                                .foregroundColor(.white)
                                .padding(.vertical)
                                    .background(Color.blue)
                                    .cornerRadius(32)
                                    .padding(.horizontal)
                                    .shadow(radius: 5)
                                    .padding(.bottom, 10)
                            }
                            ForEach(vm.recentMessages) { recentMessage in
                                VStack{
                                    Button {
                                        let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromID ? recentMessage.toID : recentMessage.fromID
                                        self.chatUser = .init(data: [FirebaseConstant.email: recentMessage.email, FirebaseConstant.uid: uid])
                                        self.chatLogViewModel.chatUser = self.chatUser
                                        self.chatLogViewModel.fetchMessages()
                                        self.shouldNavigateToChatLogView.toggle()
                                    } label: {
                                        HStack(spacing: 16){
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 40, height: 40)
                                                .clipped()
                                                .cornerRadius(50)
                                                .overlay(RoundedRectangle(cornerRadius: 44)
                                                    .stroke(Color(.label), lineWidth: 1))
                                                .shadow(radius:5)
                                            VStack(alignment: .leading){
                                                Text(recentMessage.username)
                                                    .font(.system(size: 16, weight: .bold))
                                                Text(recentMessage.text)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(Color(.darkGray))
                                                    .multilineTextAlignment(.leading)
                                            }
                                            Spacer()
                                            Text(recentMessage.timeAgo)
                                                .font(.system(size: 14, weight: .semibold))

                                    }
                                        .foregroundColor(Color(.label))
                                }
                                }
//                                .padding(.bottom, 100)

                                Divider()
                                    .padding(.vertical, 8)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 100)
                        //                        .padding([.top, .leading, .trailing])
//                        Spacer()
                        //                        .padding(.bottom)
                        ZStack{
                            Color(hex: "fff")
                                .ignoresSafeArea()
                                .padding(.top, 550.0)
                            VStack{
                                HStack{
                                    NavigationLink(destination: InfoView()) {
                                        
                                        Image(systemName: "info.circle.fill")
                                            .font(.system(size: 60, weight: .bold))
                                            .foregroundColor(Color(.label))
                                        
                                    }
                                    .padding(.trailing)
//                                    NavigationLink(destination: NewScrumSheet(scrums: $scrums, isPresentingNewScrumView: $isPresentingNewScrumView)) {
//                                        
//                                        Image(systemName: "gearshape.circle.fill")
//                                            .font(.system(size: 50, weight: .bold))
//                                            .foregroundColor(Color(.label))
//                                        
//                                    }
//                                    .padding(.trailing)

                                    Button(action: {
                                        isPresentingNewScrumView = true
                                    }){
                                        Image(systemName: "gearshape.circle.fill")
                                            .font(.system(size: 60, weight: .bold))
                                            .foregroundColor(Color(.label))
                                        
                                        
                                    }
                                    .padding(.trailing)
                                    NavigationLink(destination: Messages(scrums: $scrums)) {
                                        Image(systemName: "message.circle.fill")
                                            .font(.system(size: 60, weight: .bold))
                                            .foregroundColor(Color(.label))
                                    }
                                }
                                .padding(.top, 160.0)
                            }
                            .padding(.top, 400.0)
                        }
                        .sheet(isPresented: $isPresentingNewScrumView) {
                            NewScrumSheet(scrums: $scrums, isPresentingNewScrumView: $isPresentingNewScrumView)
            //                List($scrums) { $scrum in
            //                    DetailView(scrums: $scrums, isPresentingNew: $isPresentingNewScrumView)
            //                }
            //
             
                        }
                    }
                        
//                        Spacer()
                        
                    }
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(vm: chatLogViewModel)
                }
                

                }
//            .overlay(
//                Button {
//                    shouldShowLogOutOptions.toggle()
//                } label: {
//                    HStack{
//                        Spacer()
//                        Text("+ New Message")
//                            .font(.system(size: 16, weight: .bold))
//                        Spacer()
//                    }
//                    .foregroundColor(.white)
//                    .padding(.vertical)
//                        .background(Color.blue)
//                        .cornerRadius(32)
//                        .padding(.horizontal)
//                        .shadow(radius: 5)
//                        .padding(.top, 60)
//                }, alignment: .top)
                .navigationBarHidden(true)
            }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
//            NewMessageView(scrums: .constant(DailyScrum.sampleData)) { user in
//                print(user.email)
//            }
            NewMessageView(didSelectNewUser: { user in
                print(user.email)
                self.shouldNavigateToChatLogView.toggle()
                self.chatUser = user
                self.chatLogViewModel.chatUser = user
                self.chatLogViewModel.fetchMessages()
            }, scrums: .constant(DailyScrum.sampleData))
        }
    }
    @State var chatUser: ChatUser?
}



#Preview {
    Messages(scrums: .constant(DailyScrum.sampleData))
}
