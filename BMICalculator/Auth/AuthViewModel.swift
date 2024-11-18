//
//  ContentViewModel.swift
//  BMICalculator
//
//  Created by Ujjwal Arora on 17/11/24.
//

import Foundation
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user = Auth.auth().currentUser
    
    @Published var email = "ujjwal@gmail.com"
    @Published var password = "qqqqqq"
    
    var emailAuthMethods = ["Sign Up","Log In"]
    @Published var selectedEmailAuthMethod = "Log In"
    
    @Published var showPasswordResetAlert = false
    
    func authSignUp(email: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        user = result.user
    }
    func authLogIn(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        user = result.user
    }
    func signOut() throws{
        try Auth.auth().signOut()
        user = nil
    }
    func deleteAccount(){
        Auth.auth().currentUser?.delete()
        user = nil
    }
    func passwordReset(){
        Auth.auth().sendPasswordReset(withEmail: email)
    }
}
