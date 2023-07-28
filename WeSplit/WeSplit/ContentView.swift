//
//  ContentView.swift
//  WeSplit
//
//  Created by Batuhan Yetgin on 27.07.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused : Bool
    let tipPercentages = [10,15,20,25,0]
    var totalPerPerson : Double {
        let totalPeople = Double(numberOfPeople + 2)
        let tip = Double(tipPercentage)
        let tipAmount = checkAmount / 100 * tip
        
        let amountPerPerson = (checkAmount + tipAmount) / totalPeople
        return amountPerPerson
    }
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "EUR" ) )
                        .keyboardType(.numberPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100){
                            Text("\($0) people")
                        }
                    }
                }
                
                Section{
                    Picker("Tip percentage" , selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                        
                    }.pickerStyle(.segmented)
                } header: {
                    Text("Choose your tip percentage")
                }
                
                Section{
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
                }
            }
            .navigationTitle("WeSplit")
            .toolbar{
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
