//
//  Constants.swift
//  SyscoAssignment
//
//  Created by Mithsen on 2022-05-27.
//

import Foundation

enum Constants {
    
    enum URL {
        static let base = "https://swapi.dev/api"
    }
    
    enum EndPoints {
        static let urlListPlanets = "/planets"
        static let urlImages = "https://picsum.photos/seed"
    }
    
    enum PlanetCellKeys:String {
        case nibName = "PlanetTableViewCell"
        case reuseIdentifier = "PlanetCell"
    }
    
    enum PlanetListSpinningType {
        case none
        case footer
        case main
    }
}
