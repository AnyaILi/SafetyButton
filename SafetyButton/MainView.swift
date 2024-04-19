//
//  MainView.swift
//  SafetyButton
//
//  Created by Anya Li on 4/15/24.
//

import SwiftUI



class MainViewModel: ObservableObject {
    
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

struct MainView: View {
    @State var shouldShowLogOutOptions = false
    @ObservedObject private var vm = MainViewModel()
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
                    VStack{
                        Text("Your Situation")
                            .font(.system(size: 35, weight: .bold))
                        Text("Pick which option applies to you!")
                            .font(.system(size: 14, weight: .medium))
                            .padding(.bottom)
                        NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                            HStack{
                              VStack(alignment: .leading){
                                Text("Car Ride")
                                      .font(.system(size: 30))
                                  .foregroundColor(Color(hex: "000"))
                                  
                           }
                              .frame(maxWidth: .infinity, alignment: .center)
//                              Image(systemName: "chevron.right")
//                                .foregroundColor(Color.black)
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 30)
                        .background(Color.white)
                        .border(.black, width: 7)
                        .mask(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius:5)
                        
                      }
                        .padding([.top, .leading, .trailing])
                        NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                            HStack{
                              VStack(alignment: .leading){
                                Text("Meeting Someone New")
                                      .font(.system(size: 27))
                                  .foregroundColor(Color(hex: "000"))
                                  
                           }
                              .frame(maxWidth: .infinity, alignment: .center)
//                              Image(systemName: "chevron.right")
//                                .foregroundColor(Color.black)
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 30)
                        .background(Color.white)
                        .border(.black, width: 7)
                        .mask(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius:5)
                        
                      }
                        .padding([.top, .leading, .trailing])
                        
                        NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                            HStack{
                              VStack(alignment: .leading){
                                Text("Unsafe Conversation")
                                      .font(.system(size: 30))
                                  .foregroundColor(Color(hex: "000"))
                                  
                           }
                              .frame(maxWidth: .infinity, alignment: .center)
//                              Image(systemName: "chevron.right")
//                                .foregroundColor(Color.black)
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 30)
                        .background(Color.white)
                        .border(.black, width: 7)
                        .mask(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius:5)
                        
                      }
                        .padding([.top, .leading, .trailing])
                        
                        NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                            HStack{
                              VStack(alignment: .leading){
                                Text("Other")
                                      .font(.system(size: 30))
                                  .foregroundColor(Color(hex: "000"))
                                  
                           }
                              .frame(maxWidth: .infinity, alignment: .center)
//                              Image(systemName: "chevron.right")
//                                .foregroundColor(Color.black)
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 30)
                        .background(Color.white)
                        .border(.black, width: 7)
                        .mask(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius:5)
                            
                        
                        
                      }
                        .padding([.top, .leading, .trailing])
//                        Spacer()
                        .padding(.bottom)
                        ZStack{
                            Color(hex: "fff")
                                .ignoresSafeArea()
                            VStack{
                                HStack{
                                    NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                                        
                                        Image(systemName: "info.circle.fill")
                                            .font(.system(size: 60, weight: .bold))
                                            .foregroundColor(Color(.label))
                                        
                                    }
                                    .padding(.trailing)
                                    NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                                        Image(systemName: "gearshape.circle.fill")
                                            .font(.system(size: 60, weight: .bold))
                                            .foregroundColor(Color(.label))
                                        
                                        
                                    }
                                    .padding(.trailing)
                                    NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                                        Image(systemName: "message.circle.fill")
                                            .font(.system(size: 60, weight: .bold))
                                            .foregroundColor(Color(.label))
                                    }
                                }
                                .padding(.top)
                            }
                        }
                        
//                        Spacer()
                        
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    MainView()
}
