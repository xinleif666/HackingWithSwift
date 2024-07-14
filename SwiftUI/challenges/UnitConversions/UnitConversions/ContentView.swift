//
//  ContentView.swift
//  UnitConversions
//
//  Created by Xinlei Feng on 7/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var inputValue = 0.0
    @State private var inputUnit = ""
    @State private var outputUnit = ""
    
    let lengthUnit = ["meters", "kilometers", "feet", "yards", "miles"]
    
    var outputValue: Double {
        var input2Meters: Double
        
        switch(inputUnit) {
        
        case "meters":
            input2Meters = inputValue
            
        case "kilometers":
            input2Meters = inputValue * 1000
            
        case "feet":
            input2Meters = inputValue / 3.281
            
        case "yards":
            input2Meters = inputValue / 1.09361
            
        case "miles":
            input2Meters = inputValue * 1609.34
            
        default:
            input2Meters = 0
        }
        
        var calculateOutput: Double
        
        switch(outputUnit) {
        case "meters":
            calculateOutput = input2Meters
            
        case "kilometers":
            calculateOutput = input2Meters / 1000
            
        case "feet":
            calculateOutput = input2Meters * 3.281
            
        case "yards":
            calculateOutput = input2Meters * 1.094
            
        case "miles":
            calculateOutput = input2Meters / 1609.34
            
        default:
            calculateOutput = 0
        }
        
        return calculateOutput
    }
    
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Length conversion") {
                    TextField("Input a value to convert", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                }
                
                Section("Choose input unit") {
                    Picker("Input unit", selection: $inputUnit) {
                        ForEach(lengthUnit, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                    
                Section("Choose output unit") {
                    Picker("Output unit", selection: $outputUnit) {
                        ForEach(lengthUnit, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Converted value") {
                    Text(outputValue.formatted())
                }
            }
            .navigationTitle("Unit Conversions")
        }
    }
}

#Preview {
    ContentView()
}
