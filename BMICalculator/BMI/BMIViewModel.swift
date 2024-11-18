//
//  CoreDataViewModel.swift
//  BMICalculator
//
//  Created by Ujjwal Arora on 16/11/24.
//

import Foundation
import CoreData


class BMIViewModel : ObservableObject{
    
    let manager = CoreDataManager.shared
    
    @Published var users: [UserEntity] = []
    @Published var selectedUser: UserEntity?
    
    @Published var showUpdateDetailsView = false
    @Published var showDeleteAccountAlert = false

    
    @Published var bmi : Double?
    @Published var weightsOfSelectedUser: [WeightEntity] = []
    
    @Published var newWt = 100.0
    @Published var newHt = 200.0
    @Published var name = "Ujjwal"
    @Published var age = 20.0
    @Published var gender : Genders = .male
    
    @Published var weightUnit : WeightUnits = .kg
    @Published var heightUnit : HeightUnits = .cm
    
    func selectFirstUser(){
        if let firstUser = users.first{
            selectedUser = firstUser
        }else{
            selectedUser = nil
        }
    }
    func addUser(){
        let newUser = UserEntity(context: manager.context)
        newUser.name = name
        newUser.age = age
        newUser.gender = gender.rawValue
        
        let heightInCM = heightUnit == .cm ? newHt : newHt/0.0328
        newUser.height = heightInCM

        let newWeight = WeightEntity(context : manager.context)
        let weightInKg = weightUnit == .kg ? newWt : newWt*0.45
        newWeight.weight = weightInKg
        newWeight.date = Date()
        newWeight.user = newUser
        
        
        manager.save()
        selectedUser = newUser
    }
    func updateDetails(){
        let newWeight = WeightEntity(context : manager.context)
        let weightInKg = weightUnit == .kg ? newWt : newWt*0.45
        newWeight.weight = weightInKg
        newWeight.date = Date()
        newWeight.user = selectedUser
        
        let heightInCM = heightUnit == .cm ? newHt : newHt/0.0328
        selectedUser?.height = heightInCM
        
        manager.save()
        getUsersAndTheirWeights()
    }
    func getUsersAndTheirWeights(){
            users = manager.fetchUsers()
            getWeightsOfSelectedUser()
    }
    func calcBMI(){
        getWeightsOfSelectedUser()
        let lastWeight = weightsOfSelectedUser.last?.weight ?? 1
        let ht = selectedUser?.height ?? 1
        print(lastWeight, ht)
        bmi = lastWeight/pow(ht/100, 2)
    }
    func getWeightsOfSelectedUser(){
        if let weightsSet = selectedUser?.weights as? Set<WeightEntity> {
            weightsOfSelectedUser = Array(weightsSet).sorted(by: { $0.date ?? Date() < $1.date ?? Date() }) 
        }
    }
    func deleteUserAndItsWeights(){
        if let user = selectedUser {
            manager.context.delete(user)
            manager.save()
            getUsersAndTheirWeights()
            selectFirstUser()
        }
    }

}

