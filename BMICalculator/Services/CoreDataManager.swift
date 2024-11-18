//
//  CoreDataManager.swift
//  BMICalculator
//
//  Created by Ujjwal Arora on 17/11/24.
//

import Foundation
import CoreData

class CoreDataManager{
    static let shared = CoreDataManager()
    
    let container : NSPersistentContainer
    let context : NSManagedObjectContext
    
    init (){
        container = NSPersistentContainer(name: "UserContainer")
        container.loadPersistentStores { (desription, error) in
            if let error = error{
                print("Error loading core data: \(error)")
            }
        }
        context = container.viewContext
    }
    func save(){
        do{
            try context.save()
            print("Saved to Core Data")
        }catch{
            print("Error saving Core Data: \(error.localizedDescription)")
        }
    }
    func fetchUsers() -> [UserEntity]{
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        
        do{
            let users = try context.fetch(request)
            print("fetched users : \(users.count)")
            return users
                        
        }catch{
            print("Error fetching users: \(error.localizedDescription)")
            return []
        }
    }
    
}
