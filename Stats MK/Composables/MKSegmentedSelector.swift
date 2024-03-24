//
//  MKSegmentedSelector.swift
//  Stats MK
//
//  Created by Pascal Alberti on 25/02/2024.
//

import SwiftUI


struct MKSegmentedSelector: View {
    
    private let itemsList: [String]
    
    @State var selection: String
    var onValueChange: (String) -> Void
    
    init(itemsList: [String], defaultValue: String, onValueChange: @escaping (String) -> Void) {
        UISegmentedControl.appearance().backgroundColor = UIColor(hexColor: .white).withAlphaComponent(0.1)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(hexColor: .harmoniaDark)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(hexColor: .white)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(hexColor: .harmoniaDark)], for: .normal)
        self.itemsList = itemsList
        self.onValueChange = onValueChange
        self.selection = defaultValue
    }
    
    var body: some View {
        Picker("", selection: $selection) {
            ForEach(itemsList, id: \.self) { value in
                Text(value).tag(value)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .onChange(of: selection) { old, new in
            onValueChange(new)
        }
    }
}
