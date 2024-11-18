//
//  BMICalcView.swift
//  BMICalculator
//
//  Created by Ujjwal Arora on 16/11/24.
//

import SwiftUI
import CoreData
import Charts
import FirebaseAuth

struct BMICalcView: View {
    @StateObject private var vm = BMIViewModel()
    @EnvironmentObject var authvm: AuthViewModel
    
    var body: some View {
        VStack{
            if vm.users.isEmpty {
                NavigationLink("Add new User", destination: AddUserView(addUser: true, vm: vm)
                )
            }else{
                
                Picker("Select user", selection: $vm.selectedUser) {
                    ForEach(vm.users, id: \.self) { user in
                        Text(user.name ?? "no name")
                            .tag(user as UserEntity?)
                    }
                }
                .pickerStyle(.segmented)
                
                if vm.selectedUser != nil {
                    Text("Age : \(vm.age.formatted(.number))")
                    Text("Gender : \(vm.selectedUser?.gender ?? "no info")")
                    Text("Height : \(vm.selectedUser?.height.formatted(.number) ?? "no info")")
                    HStack {
                        Text("BMI : \(vm.bmi?.formatted(.number.precision(.fractionLength(2))) ?? "")")
                        Spacer()
                        Text(vm.getBMICategory)
                    }
                    
                    Chart {
                        ForEach(vm.weightsOfSelectedUser) { wt in
                            LineMark(x: .value("Date", wt.date ?? Date()), y: .value("Wt", wt.weight))
                        }
                    }
                    .foregroundStyle(.green)
                    .frame(height: (300))
                    Button {
                        vm.deleteUserAndItsWeights()
                        vm.selectFirstUser()
                    } label: {
                        Text("Delete user data")
                    }
                    
                }
                
                Spacer()
            }
        }.padding()
        .sheet(isPresented: $vm.showUpdateDetailsView, content: { AddUserView(addUser: false, vm: vm) })
        .alert("You want to delete your account ?", isPresented: $vm.showDeleteAccountAlert, actions: {
            Button("Delete", role: .destructive) {
                authvm.deleteAccount()
            }
        })
        .toolbar(content: {
            if vm.selectedUser != nil {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Update Weight/Height", action: {
                        vm.showUpdateDetailsView = true
                    })
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    NavigationLink("Add new User", destination: AddUserView(addUser: true, vm: vm)
                    )
                    
                    Button("Delete Account") {
                        vm.showDeleteAccountAlert = true
                    }
                    Button("Sign Out") {
                        do{
                            try authvm.signOut()
                        }catch{
                            print(error.localizedDescription)
                        }
                    }

                } label: {
                    Image(systemName: "gear")
                }
                

            }
        })
        .onAppear {
            vm.getUsersAndTheirWeights()
            if vm.selectedUser == nil{
                vm.selectFirstUser()
            }
        }
        .onChange(of: vm.selectedUser) { _, _ in
            vm.calcBMI()
        }
    }
}

#Preview {
    NavigationStack {
        BMICalcView()
            .environmentObject(AuthViewModel())
    }
}
