//
//  MKPenaltyView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 23/01/2024.
//

import SwiftUI

struct MKPenaltyView: View {
    
    let penalties: [MKPenalty]
    
    var body: some View {
        if (!penalties.isEmpty) {
            HStack(alignment: .center) {
                VStack {
                    MKTextView(label: "Pénalités :", font: "Montserrat-Bold", fontSize: 12)
                        .padding(.bottom, 10)
                    VStack {
                        ForEach(penalties) { penalty in
                            HStack {
                                MKTextView(label: penalty.teamTag, fontSize: 12)
                                MKTextView(label: "-\(penalty.amount)", fontSize: 12)
                            }
                        }
                    }
                }
                Spacer()
            }.frame(maxWidth: .infinity)
                .padding(.leading, 30)
           
        }
    }
}

