//
//  PlanetTableViewCell.swift
//  SyscoAssignment
//
//  Created by Mithsen on 2022-05-28.
//

import UIKit

class PlanetTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblClimate: UILabel!
    
    var planetDetail: PlanetDetail? {
      didSet {
        configureCell()
      }
    }
}

extension PlanetTableViewCell {
  private func configureCell() {
    guard let planetDetail = self.planetDetail else { return }
    lblName.text = planetDetail.name
    lblClimate.text = planetDetail.climate
  }
}
