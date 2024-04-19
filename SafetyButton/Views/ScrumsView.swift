//
//  ScrumsView.swift
//  SafetyButton
//
//  Created by Anya Li on 4/16/24.
//

import SwiftUI


class ScrumsViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    
    
    init() {
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
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
    @Published var isUserCurrentlyLoggedOut = false
    func handleSignOut(){
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresentingNewScrumView = false
    let saveAction: ()->Void
    @State var shouldShowLogOutOptions = false
    @ObservedObject private var vm = ScrumsViewModel()
    @State private var isRecording = false


    var body: some View {
        NavigationStack{
            VStack{
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
                
                
                NavigationStack {
                    List{
                        
                        ForEach ($scrums) { $scrum in
                            NavigationLink(destination: DetailView(scrums: $scrums, scrum: $scrum)) {
                                CardView(scrum: scrum)
                            }
                            .listRowBackground(Color(hex: "FFEBEB"))
                        }
                        .onDelete(perform: { indexSet in
                            scrums.remove(atOffsets: indexSet)
                        })
                    }
                    .navigationTitle("Recordings")
                    .toolbar {
                        Button(action: {
                            isRecording = true
                            //                        NewRecording(scrums: $scrums, isPresentingNewScrumView: $isPresentingNewScrumView)
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(Color(.label))
                        }
                        .accessibilityLabel("New Scrum")
                    }
                    
                    
                }
                ZStack{
                    //                Color(hex: "fff")
                    //                    .ignoresSafeArea()
                    VStack{
                        HStack{
                            NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                                
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(Color(.label))
                                
                            }
                            .padding(.trailing)
                            //                        NavigationLink(destination: NewScrumSheet(scrums: $scrums, isPresentingNewScrumView: $isPresentingNewScrumView)){
                            //                            Image(systemName: "gearshape.circle.fill")
                            //                                .font(.system(size: 60, weight: .bold))
                            //                                .foregroundColor(Color(.label))
                            //                        }
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
                        .padding(.top)
                    }
                }
                //            .padding(.top, 60.0)
                
                .sheet(isPresented: $isRecording) {
                    NewRecording(scrums: $scrums, isRecording: $isRecording)
                    //                List($scrums) { $scrum in
                    //                DetailView(scrums: $scrums, isPresentingNew: $isPresentingNewScrumView)
                    //                }
                    
                    
                }
                .sheet(isPresented: $isPresentingNewScrumView) {
                    NewScrumSheet(scrums: $scrums, isPresentingNewScrumView: $isPresentingNewScrumView)
                    //                List($scrums) { $scrum in
                    //                    DetailView(scrums: $scrums, isPresentingNew: $isPresentingNewScrumView)
                    //                }
                    //                
                    
                }
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive { saveAction() }
                }
            }
        }
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
    }
}
