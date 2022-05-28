//
//  DataModel.swift
//  SyscoAssignment
//
//  Created by Mithsen on 2022-05-28.
//

import Foundation

struct PlanetDataModel: Codable {
    let count:Int?
    let next:String?
    let previous:String?
    let results:[PlanetDetail]?
}

struct PlanetDetail: Codable {
    let name: String?
    let climate:String?
    let orbital_period:String?
    let gravity:String?
}

