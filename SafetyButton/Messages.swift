//
//  MainView.swift
//  SafetyButton
//
//  Created by Anya Li on 4/15/24.
//

import SwiftUI



class MessagesModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var isUserCurrentlyLoggedOut = false
    
    init() {
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = false
//            FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
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
                            ForEach(0..<10, id: \.self) { num in
                                VStack{
                                    NavigationLink {
                                        Text("Destination")
                                    } label: {
                                        HStack(spacing: 16){
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 32))
                                                .padding()
                                                .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color.black, lineWidth: 1))
                                            VStack(alignment: .leading){
                                                Text("Username")
                                                    .font(.system(size: 16, weight: .bold))
                                                Text("Message sent to user")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(Color(.lightGray))
                                            }
                                            Spacer()
                                            Text("22d")
                                                .font(.system(size: 14, weight: .semibold))

                                    }
                                        .foregroundColor(Color(.label))
                                }
                                }
                                Divider()
                                    .padding(.vertical, 8)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 50)
                        //                        .padding([.top, .leading, .trailing])
//                        Spacer()
                        //                        .padding(.bottom)
                        ZStack{
                            Color(hex: "fff")
                                .ignoresSafeArea()
                                .padding(.top, 550.0)
                            VStack{
                                HStack{
                                    NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                                        
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
                    ChatLogView(chatUser: self.chatUser)
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
            }, scrums: .constant(DailyScrum.sampleData))
        }
    }
    @State var chatUser: ChatUser?
}



#Preview {
    Messages(scrums: .constant(DailyScrum.sampleData))
}
