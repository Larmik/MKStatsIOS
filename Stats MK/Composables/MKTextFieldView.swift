//
//  MKTextFieldView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 17/01/2024.
//

import SwiftUI

struct MKTextFieldView: View {
    
    @State var value = ""
    @State var passwordMode = false
    
    var placeHolder = ""
    var onValueChange: (String) -> Void
    let type: UIKeyboardType
    
    @State private var isSecured: Bool = true
    
    init(passwordMode: Bool, placeHolder: String, type: UIKeyboardType = .default, onValueChange: @escaping (String) -> Void) {
        self.passwordMode = passwordMode
        self.placeHolder = placeHolder
        self.onValueChange = onValueChange
        self.type = type
    }
    
    var normalField: some View {
        TextField("", text: $value, prompt: Text(placeHolder).foregroundStyle(Color.black).font(.system(size: 13)))
            .keyboardType(self.type)
            .foregroundColor(Color.black)
            .onChange(of: value) { old, new in
                onValueChange(new)
            }
    }
    
    var secureField: some View {
        SecureField("", text: $value,  prompt: Text(placeHolder).foregroundStyle(Color.black).font(.system(size: 13)))
          .foregroundColor(Color.black)
          .onChange(of: value) { old, new in
              onValueChange(new)
          }
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if (passwordMode) {
                Group {
                    if isSecured {
                        secureField
                    } else {
                        normalField
                    }
                }.padding(.trailing, 32)
                Button(action: {
                    isSecured.toggle()
                }) {
                    Image(self.isSecured ? "visible" : "hidden")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }.frame(width: 28, height: 22)
            } else {
                normalField
            }
        }
        .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(
                    Color.black,
                    lineWidth: 1.2
                )
        )
        .background(Color.white)
    }
}
