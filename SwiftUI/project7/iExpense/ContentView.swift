//
//  ContentView.swift
//  iExpense
//
//  Created by Paul Hudson on 15/10/2023.
//  Modified by Xinlei Feng on 15/07/2024.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }

    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }

        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()

    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal expense") {
                    ForEach(expenses.items.filter { $0.type == "Personal" }) { item in
                        expenseRow(for: item)
                    }
                    .onDelete(perform: removeItems)
                }
                
                Section("Business expense") {
                    ForEach(expenses.items.filter { $0.type == "Business" }) { item in
                        expenseRow(for: item)
                    }
                    .onDelete(perform: removeItems)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }

    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func checkAmountLevel(value: Double) -> Color {
        if value <= 10 {
            return .green
        } else if value > 10 && value <= 100 {
            return .blue
        } else {
            return .red
        }
    }
    
    @ViewBuilder
    func expenseRow(for item: ExpenseItem) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)

                Text(item.type)
            }

            Spacer()
            
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .foregroundStyle(checkAmountLevel(value: item.amount))
        }
    }
}

#Preview {
    ContentView()
}
