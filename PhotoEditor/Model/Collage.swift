//
//  Collage.swift
//  PhotoEditor
//
//  Created by Raees on 11/01/2023.
//

import Foundation

enum Collage : String {
    case diagonal = "Diagonal"
    case horizantal = "Horizantal"
    case vertical = "Vertical"
    
    var index : Int {
        get {
            switch self {
            case .diagonal:
                return 0
            case .horizantal:
                return 1
            case .vertical:
                return 2
            }
        }
    }
    init(index: Int) {
        switch index {
        case 0:
            self = .diagonal
        case 1:
            self = .horizantal
        case 2:
            self = .vertical
        default:
            self = .diagonal
        }
    }
}
