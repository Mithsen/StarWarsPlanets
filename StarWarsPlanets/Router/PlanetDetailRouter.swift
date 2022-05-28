//
//  PlanetDetailRouter.swift
//  SyscoAssignment
//
//  Created by Mithsen on 2022-05-28.
//

import UIKit

class PlanetDetailRouter {
    private weak var sourceView: UIViewController?
}

extension PlanetDetailRouter {
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else { return }
        self.sourceView = view
    }
    
    func createViewController(planetDetail: PlanetDetail) -> UIViewController {let detailView = PlanetDetailViewController(nibName: "PlanetDetailViewController", bundle: Bundle.main)
        detailView.planetDetail = planetDetail
        return detailView
    }
}

