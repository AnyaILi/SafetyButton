//
//  ContentView.swift
//  SafetyButton
//
//  Created by Anya Li on 4/5/24.
//

import SwiftUI
import Firebase


struct LoginView: View {
    let didCompleteLoginProcess: () -> ()
    
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var isLoginScreen = false
    @State private var showingLoginScreen = false
   
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack (spacing : 16){
                    Picker(selection: $isLoginScreen, label: Text("Picker here")) {
                        Text("Log In")
                            .tag(false)
                        Text("Create Account")
                            .tag(true)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    if isLoginScreen{
                        
//                        Button{
//                            
//                        } label:{
                        Image(systemName: "person.fill")
                            .font(.system(size:64))
                            .padding()
                            .foregroundColor(Color(hex: "000"))
//                        }
                            .padding(.bottom)
                    }
                    else{
                        Spacer()
                        Spacer()
                    }
                    TextField("Email", text: $username)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUsername))
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                    Button(isLoginScreen ? "Create Account" : "Log In"){
                        authenticateUser()
                        
                    }
                    .foregroundColor(.black)
                    .frame(width: 300, height:50)
                    .background(.white)
                    .border(.black, width: 5)
//                    .cornerRadius(10)
                    
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
            }
            .navigationTitle(isLoginScreen ? "Create Account" : "Log In")
            .background(Color(hex: "FFEBEB")
                .ignoresSafeArea())
            
            }
        .navigationViewStyle(StackNavigationViewStyle())
        }
        
    func authenticateUser(){
        if !isLoginScreen {
            loginUser()
        }
        else{
            createNewAccount()
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: username, password: password) {
            result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.loginStatusMessage = "Failed to login user: \(err)"
                return
            }
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            
            self.didCompleteLoginProcess()

        }
    }
    
    @State var loginStatusMessage = ""
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: username, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            
            self.storeUserInformation()
        }
    }
    private func storeUserInformation() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return }
        let userData = ["email": self.username, "uid": uid]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                print("success")
                self.didCompleteLoginProcess()
            }
        }
    }


#Preview {
    LoginView(didCompleteLoginProcess: {
        
    })
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
