//
//  PlanetListRouter.swift
//  SyscoAssignment
//
//  Created by Mithsen on 2022-05-27.
//

import UIKit

class PlanetListRouter {
    private weak var sourceView: UIViewController?
}

extension PlanetListRouter {
    func setSourceView(_ sourceView: UIViewController?) {
        guard let view = sourceView else { fatalError("Error setting source view") }
        self.sourceView = view
    }
    
    func naviagteToDetailView(planetDetail: PlanetDetail) {
        let detailView = PlanetDetailRouter().createViewController(planetDetail: planetDetail)
        sourceView?.navigationController?.pushViewController(detailView, animated: true)
    }
}
