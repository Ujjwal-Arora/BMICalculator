//
//  GoogleSignInHelper.swift
//  BMICalculator
//
//  Created by Ujjwal Arora on 16/11/24.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

final class GoogleSignInHelper{
    
    @MainActor
    func signIn() async throws -> AuthDataResult{
        guard let topVC = Utilities.shared.topViewController() else { throw URLError(.cannotFindHost) }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else { throw URLError(.badServerResponse) }
        
        let accessToken = gidSignInResult.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        return try await Auth.auth().signIn(with: credential)

    }
}
