//
//  AddView.swift
//  iExpense
//
//  Created by Batuhan Yetgin on 11.09.2023.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var expenses : Expenses
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var type = "Personel"
    @State private var amount = 0.0
    let types = ["Personel", "Business"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Types" , selection: $type) {
                    ForEach(types , id : \.self) {
                        Text($0)
                    }
                }
                
                TextField("Name", value: $amount , format: .currency(code: "USD") )
                    .keyboardType(.decimalPad)
                
                
            }
            .navigationTitle("Add new expense")
            .toolbar{
                Button("Save"){
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    
                    dismiss()
                    
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
