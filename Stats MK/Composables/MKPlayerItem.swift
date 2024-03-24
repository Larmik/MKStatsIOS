//
//  MKPlayerItem.swift
//  Stats MK
//
//  Created by Pascal Alberti on 24/01/2024.
//

import SwiftUI

struct MKPlayerItem: View {
    
    let position: MKPlayerWarPosition?
    let player: UserSelector?
    let shockCount: Int
    let shockVisible: Bool
    let onAddShock: (String) -> Void
    let onRemoveShock: (String) -> Void
    let onClick: () -> Void
    
    init(position: MKPlayerWarPosition?, shockCount: Int, shockVisible: Bool, onAddShock: @escaping (String) -> Void = { _ in }, onRemoveShock: @escaping (String) -> Void = { _ in }) {
        self.position = position
        self.player = nil
        self.shockCount = shockCount
        self.onClick = {}
        self.shockVisible = shockVisible
        self.onAddShock = onAddShock
        self.onRemoveShock = onRemoveShock
    }
    
    init(player: UserSelector, onClick: @escaping () -> Void) {
        self.player = player
        self.position = nil
        self.shockCount = 0
        self.onClick = onClick
        self.shockVisible = false
        self.onAddShock = { _ in }
        self.onRemoveShock = { _ in }
    }
    
    var body: some View {
        
        var textColor: Color {
            return switch (self.player?.selected) {
            case true: Color(UIColor(hexColor: .white))
            default: Color(UIColor(hexColor: .black))
            }
        }
        var bgColor: Color {
            return switch (self.player?.selected) {
            case true: Color(UIColor(hexColor: .harmoniaDark))
            default: Color(UIColor(hexColor: .white).withAlphaComponent(0.5))
            }
        }
        
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 35, height: 35)
            Spacer()
            MKTextView(label: position?.mkcPlayer?.name ?? player?.player.name ?? "", font: "Montserrat-Bold", fontSize: 16, fontColor: textColor)
            if (shockCount > 0) {
                Image("shock")
                .resizable()
                .frame(width: 15, height: 15)
                
            
            MKTextView(label: "x\(shockCount)", font: "Orbitron-SemiBold")
                .offset(x: -8)
            }
            
            Spacer()
            if (position != nil) {
                MKTextView(label: "\(position?.position.position ?? 0)", font: "MarioKartPositionFontRegular", fontSize: 26, fontColor: Color(UIColor(intColor: positionColor(position: position?.position.position ?? 0))))
                if (shockVisible) {
                    Spacer()
                    HStack {
                        MKTextView(label: "-", font: "Orbitron-SemiBold", fontSize: 26).onTapGesture {
                            onRemoveShock(position?.mkcPlayer?.mkcId ?? "")
                        }
                        Image("shock").resizable().frame(width: 20, height: 20)
                        MKTextView(label: "+", font: "Orbitron-SemiBold", fontSize: 26).onTapGesture {
                            onAddShock(position?.mkcPlayer?.mkcId ?? "")
                        }
                        
                    }
                }
            }
        }.padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(bgColor)
            .cornerRadius(5)
            .onTapGesture {
                onClick()
            }
    }
}
