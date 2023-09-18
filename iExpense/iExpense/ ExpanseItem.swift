//
//   ExpanseItem.swift
//  iExpense
//
//  Created by Batuhan Yetgin on 8.09.2023.
//

import Foundation

struct ExpenseItem : Identifiable, Codable {
    var id = UUID()
    let name : String
    let type : String
    let amount : Double
}
