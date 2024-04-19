//
//  NewMessageView.swift
//  SafetyButton
//
//  Created by Anya Li on 4/18/24.
//

import SwiftUI
class NewMessageViewModel: ObservableObject{
    
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    init(){
        fetchAllUsers()
    }
    
    private func fetchAllUsers(){
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments{ documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let user = ChatUser(data: data)
                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid{
                        self.users.append(.init(data: data))
                    }
                })
                
                self.errorMessage = "Fetched users successfully"
            }
    }
}

struct NewMessageView: View {
    let didSelectNewUser: (ChatUser) -> ()
    @Environment(\.presentationMode) var presentationMode
    @Binding var scrums: [DailyScrum]
    
    @ObservedObject var vm = NewMessageViewModel()
    var body: some View {
        NavigationView{
            ScrollView{
//                Text(vm.errorMessage)
                ForEach(vm.users){user in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
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
                                .padding(.leading)
                                .foregroundColor(Color(.label))
                            
                            Text(user.email)
                                .foregroundColor(Color(.label))
                            Spacer()
                        }
                    }
                        Divider()
                            .padding(.vertical)
                    }
                
            }.navigationTitle("New Message")
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarLeading){
                        Button{
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
        }
    }
}

#Preview {
//    NewMessageView(scrums: .constant(DailyScrum.sampleData))
    Messages(scrums: .constant(DailyScrum.sampleData))
}
