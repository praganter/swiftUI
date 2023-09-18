//
//  ContentView.swift
//  iExpense
//
//  Created by Batuhan Yetgin on 6.09.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State var isShowingAddView = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(expenses.items) { item in
                    HStack {
                        VStack {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpenses").toolbar{
                Button{
                   isShowingAddView = true
                } label: {
                    Image(systemName: "plus")
                }
            }.sheet(isPresented: $isShowingAddView){
                AddView(expenses: expenses)
            }
        }
        
        
    }
    
    func removeItems (at offsets : IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
