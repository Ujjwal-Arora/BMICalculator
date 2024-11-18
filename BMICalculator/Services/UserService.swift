//
//  UserService.swift
//  BMICalculator
//
//  Created by Ujjwal Arora on 16/11/24.
//

import Foundation
import FirebaseAuth

class UserService {
    func authSignUp(email: String, password: String) async throws -> AuthDataResult {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    func authLogIn(email: String, password: String) async throws -> AuthDataResult {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    func signOut() throws{
        try Auth.auth().signOut()
    }
    func deleteAccount(){
        Auth.auth().currentUser?.delete()
    }
}
