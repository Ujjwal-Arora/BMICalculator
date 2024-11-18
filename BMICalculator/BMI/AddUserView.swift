//
//  UpdateDetails.swift
//  BMICalculator
//
//  Created by Ujjwal Arora on 17/11/24.
//

import SwiftUI

struct AddUserView: View {
    var addUser : Bool
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var vm : BMIViewModel
    
    var body: some View {
        Form{
            if addUser{
                TextField("Enter Name", text: $vm.name)
                
                Slider(value: $vm.age, in: 0...100, step: 1)
                
                Text("Select Age : \(vm.age.formatted(.number))")
                
                Picker("gender", selection: $vm.gender) {
                    ForEach(Genders.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }.pickerStyle(.segmented)
            }
            Section{
                Text("Add weight (in \(vm.weightUnit.rawValue)) : ")
                Picker("Weight Unit", selection: $vm.weightUnit) {
                    Text("kg")
                        .tag(WeightUnits.kg)
                    Text("lbs")
                        .tag(WeightUnits.lbs)
                }
                Picker("Weight", selection: $vm.newWt) {
                    ForEach(0..<300) {
                        let displayWt = Double($0) * (vm.weightUnit == .kg ? 1 : 2.2)
                        Text((displayWt).formatted(.number) )
                            .tag(displayWt)
                    }
                }.pickerStyle(.wheel)
            }
            Section {
                Text("Add height (in \(vm.heightUnit.rawValue)) : ")
                Picker("Height Unit", selection: $vm.heightUnit) {
                    Text("cm")
                        .tag(HeightUnits.cm)
                    Text("feet")
                        .tag(HeightUnits.feet)
                }
                Picker("Weight", selection: $vm.newHt) {
                    ForEach(150..<250) {
                        let displayHeight = Double($0) * (vm.heightUnit == .cm ? 1 : 0.0328)
                        Text(displayHeight.formatted(.number) )
                            .tag(displayHeight)
                    }
                }.pickerStyle(.wheel)
            }
            
            Button {
                addUser ? vm.addUser() : vm.updateDetails()
                vm.calcBMI()
                dismiss()
            } label: {
                Text("Save")
            }
            
        }.navigationTitle("Add New User")
    }
}

#Preview {
    AddUserView(addUser: true, vm: BMIViewModel())
}

