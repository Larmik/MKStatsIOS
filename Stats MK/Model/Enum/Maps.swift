//
//  Maps.swift
//  Stats MK
//
//  Created by Pascal Alberti on 22/01/2024.
//

import Foundation

enum Maps : String, Hashable, CaseIterable {
    

    var label: String {
        switch (self) {
        case .MKS: return "Champidrome"
        case .WP: return  "Parc Gloogloop"
        case .SSC: return  "Piste aux délices"
        case .TR: return "Temple Thwomp"
        case .MC: return "Circuit Mario"
        case .TH: return "Promenade Toad"
        case .TM: return "Manoir trempé"
        case .SGF: return "Cascades Maskass"
        case .SA: return "Aéroport azur"
        case .DS: return "Lagon tourbillon"
        case .Ed: return "Club Mario"
        case .MW: return "Descente givrée"
        case .CC: return "Voie céleste"
        case .BDD: return "Désert Toussec"
        case .BC: return "Château de Bowser"
        case .RR: return "Route Arc-en-ciel"
        case .dYC: return "Circuit Yoshi"
        case .dEA: return "Arène Excitebike"
        case .dDD: return "Route du Dragon"
        case .dMC: return "Mute City"
        case .dWGM: return "Mine Wario"
        case .dRR: return "Route Arc-en-cien SNES"
        case .dIIO: return "Station Glagla"
        case .dHC: return "Circuit d'Hyrule"
        case .rMMM: return "Prairie Meuh-Meuh"
        case .rMC: return "Circuit Mario GBA"
        case .rCCB: return "Plage Cheep-Cheep"
        case .rTT: return "Autoroute Toad"
        case .rDDD: return "Désert Sec Sec"
        case .rDP3: return "Plaine Donut 3"
        case .rRRY: return "Autodrome royal"
        case .rDKJ: return "Forêt tropicale DK"
        case .rWS: return "Stade Wario"
        case .rSL: return "Royaume Sorbet"
        case .rMP: return "Piste musicale"
        case .rYV: return "Vallée Yoshi"
        case .rTTC: return "Horloge Tic-tac"
        case .rPPS: return "Egouts pirhana"
        case .rGV: return "Volcan grondant"
        case .rRRd: return "Route Arc-en-ciel N64"
        case .dBP: return "Parc Baby"
        case .dCL: return "Pays fromage"
        case .dWW: return "Passage feuillage"
        case .dAC: return "Animal Crossing"
        case .dNBC: return "Koopapolis"
        case .dRiR: return "Route ruban"
        case .dSBS: return "Métro Turbo"
        case .dBB: return "Big Blue"
        case .bPP: return "Promenade à Paris"
        case .bTC: return "Circuit Toad"
        case .bCMo: return "Montagne choco"
        case .bCMa: return "Supeermarché Coco"
        case .bTB: return "Traversée de Tokyo"
        case .bSR: return "Corniche champignon"
        case .bSG: return "Jardin volant"
        case .BNH: return "Dojo Ninja"
        case .bNYM: return "Escapade new-yorkaise"
        case .bMC3: return "Circuit Mario 3"
        case .bKD: return "Désert Kalimari"
        case .bWP: return "Flipper Waluigi"
        case .bSS: return "Sprint à Sydney"
        case .bSL: return "Pays neigeux"
        case .bMG: return "Gorge champignon"
        case .bSHS: return "Cité Sorbet"
        case .bLL: return "Détour à Londres"
        case .bBL: return "Lac Boo"
        case .bRRM: return "Mont Eboulis"
        case .bMT: return "Bois Vermeil"
        case .bBB: return "Balade berlinoise"
        case .bPG: return "Jardin Peach"
        case .bMM: return "Mont festif"
        case .bRR: return "Route Arc-en-ciel 3DS"
        case .bAD: return "Virée à Amsterdam"
        case .bRP: return "Riverside Parc"
        case .bDKS: return "Pic DK"
        case .bYI: return "Ile de Yoshi"
        case .bBR: return "Bousculade à Bangkok"
        case .bMC: return "Circuit Mario DS"
        case .bWS: return "Stade Waluigi"
        case .bSiS: return "Poursuite à Singapour"
        case .bAtD: return "Athènes antique"
        case .bDC: return "Circuit Daisy"
        case .bMH: return "Route Clair de lune"
        case .bSCS: return "Course à la propreté"
        case .bLAL: return "Road trip à Los Angeles"
        case .bSW: return "Pays crépuscule"
        case .bKC: return "Cap Koopa"
        case .bVV: return "Virages à Vancouver"
        case .bRA: return "Roma romantica"
        case .bDKM: return "Montagne DK"
        case .bDCt: return "Curcuit Daisy"
        case .bPPC: return "Ruines plante pirhana"
        case .bMD: return "Méandres madrilènes"
        case .bRIW: return "Monde glacé d'Harmonie"
        case .bBC3: return "Château de Bowser 3"
        case .bRRW: return "Route Arc-en-ciel Wii"
        }
        
    }
    
    var picture: String {
        return self.rawValue.lowercased()
    }
    
    var trackIndex: Int {
        return Maps.allCases.firstIndex(of: self) ?? 0
    }
    
    var cupPicture: String {
        switch (self) {
        case .MKS, .WP, .SSC, .TR: return "mushroom"
        case .MC, .TH, .TM, .SGF: return "flower"
        case .SA, .DS, .Ed, .MW: return "star"
        case .CC, .BDD, .BC, .RR: return "special"
        case .dYC, .dEA, .dDD, .dMC: return "egg"
        case .dWGM, .dRR, .dIIO, .dHC: return "triforce"
        case .rMMM, .rMC, .rCCB, .rTT: return "shell"
        case .rDDD, .rDP3, .rRRY, .rDKJ: return "banana"
        case .rWS, .rSL, .rMP, .rYV: return "leaf"
        case .rTTC, .rPPS, .rGV, .rRRd: return "lightning"
        case .dBP, .dCL, .dWW, .dAC: return "crossing"
        case .dNBC, .dRiR, .dSBS, .dBB: return "bell"
        case .bPP, .bTC, .bCMo, .bCMa: return "goldendash"
        case .bTB, .bSR, .bSG, .BNH: return "luckycat"
        case .bNYM, .bMC3, .bKD, .bWP: return "turnip"
        case .bSS, .bSL, .bMG, .bSHS: return "propeller"
        case .bLL, .bBL, .bRRM, .bMT: return "rock"
        case .bBB, .bPG, .bMM, .bRR: return "moon"
        case .bAD, .bRP, .bDKS, .bYI: return "boomerang"
        case .bBR, .bMC, .bWS, .bSiS: return "fruit"
        case .bAtD, .bDC, .bMH, .bSCS: return "feather"
        case .bLAL, .bSW, .bKC, .bVV: return "cherry"
        case .bRA, .bDKM, .bDCt, .bPPC: return "acorn"
        case .bMD, .bRIW, .bBC3, .bRRW: return "spiny"
        }
    }
    
    case MKS
    case WP
    case SSC
    case TR
    case MC
    case TH
    case TM
    case SGF
    case SA
    case DS
    case Ed
    case MW
    case CC
    case BDD
    case BC
    case RR
    case dYC
    case dEA
    case dDD
    case dMC
    case dWGM
    case dRR
    case dIIO
    case dHC
    case rMMM
    case rMC
    case rCCB
    case rTT
    case rDDD
    case rDP3
    case rRRY
    case rDKJ
    case rWS
    case rSL
    case rMP
    case rYV
    case rTTC
    case rPPS
    case rGV
    case rRRd
    case dBP
    case dCL
    case dWW
    case dAC
    case dNBC
    case dRiR
    case dSBS
    case dBB
    case bPP
    case bTC
    case bCMo
    case bCMa
    case bTB
    case bSR
    case bSG
    case BNH
    case bNYM
    case bMC3
    case bKD
    case bWP
    case bSS
    case bSL
    case bMG
    case bSHS
    case bLL
    case bBL
    case bRRM
    case bMT
    case bBB
    case bPG
    case bMM
    case bRR
    case bAD
    case bRP
    case bDKS
    case bYI
    case bBR
    case bMC
    case bWS
    case bSiS
    case bAtD
    case bDC
    case bMH
    case bSCS
    case bLAL
    case bSW
    case bKC
    case bVV
    case bRA
    case bDKM
    case bDCt
    case bPPC
    case bMD
    case bRIW
    case bBC3
    case bRRW
}
