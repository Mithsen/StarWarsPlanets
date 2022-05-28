//
//  PlanetDetailViewController.swift
//  SyscoAssignment
//
//  Created by Mithsen on 2022-05-28.
//

import UIKit

class PlanetDetailViewController: UIViewController {

    var planetDetail:PlanetDetail?
    
    @IBOutlet weak var planetImage: UIImageView!
    @IBOutlet weak var lblPlanetName: UILabel!
    @IBOutlet weak var lblOrbitalPeriod: UILabel!
    @IBOutlet weak var lblGravity: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPlanetData()
    }
}

extension PlanetDetailViewController {
  private func showPlanetData() {
      let imageUrl = "\(Constants.EndPoints.urlImages)/\(planetDetail?.name?.replacingOccurrences(of: " ", with: "_") ?? "picsum")/200/300"
    print("image url: \(imageUrl)")
    planetImage.imageFromServerURL(urlString: imageUrl)
    lblPlanetName.text = planetDetail?.name
    lblOrbitalPeriod.text = planetDetail?.orbital_period
    lblGravity.text = planetDetail?.gravity
  }
}
