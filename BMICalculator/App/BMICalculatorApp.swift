//
//  BMICalculatorApp.swift
//  BMICalculator
//
//  Created by Ujjwal Arora on 16/11/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct BMICalculatorApp: App {
    @StateObject private var vm = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                if vm.user?.email == nil{
                    AuthView()
                }else{
                    BMICalcView()
                }
            }.environmentObject(vm)
        }
    }
}
