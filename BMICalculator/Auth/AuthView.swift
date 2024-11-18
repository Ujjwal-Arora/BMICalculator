//
//  ContentView.swift
//  BMICalculator
//
//  Created by Ujjwal Arora on 16/11/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

struct AuthView: View {
    
    @EnvironmentObject var vm : AuthViewModel
    
    var body: some View {
        VStack(spacing : 15) {
            Picker("Select Auth Method", selection: $vm.selectedEmailAuthMethod) {
                ForEach(vm.emailAuthMethods, id: \.self) { authMethod in
                    Text(authMethod)
                }
            }.pickerStyle(.segmented)
            
            TextField("Email", text: $vm.email)
            SecureField("Password", text: $vm.password)
            
            Button {
                Task{
                    do{
                        if vm.selectedEmailAuthMethod == "Sign Up" {
                            try await vm.authSignUp(email: vm.email, password: vm.password)
                        }else{
                            try await vm.authLogIn(email: vm.email, password: vm.password)
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            } label: {
                HStack{
                    Text(vm.selectedEmailAuthMethod)
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 7).stroke(.blue, lineWidth: 1)
                }
            }
            
            Button {
                vm.showPasswordResetAlert = true
            } label: {
                Text("Forgot your password? Reset it")
                    .foregroundStyle(.blue)
                    .font(.callout)
                
            }
            .alert("Send password reset email for \(vm.email) ?", isPresented: $vm.showPasswordResetAlert) {
                Button("OK") {
                    vm.passwordReset()
                }
                Button("Cancel") {
                    
                }
            }
            GoogleSignInButton(scheme: .light, style: .wide, state: .normal) {
                Task{
                    do{
                        vm.user = try await GoogleSignInHelper().signIn().user
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            
        }
        .foregroundStyle(.black)
        .fontWeight(.semibold)
        .padding()
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}
