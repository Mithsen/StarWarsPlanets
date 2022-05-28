//
//  APIRequest.swift
//  SyscoAssignment
//
//  Created by Mithsen on 2022-05-27.
//

import Foundation
import RxSwift

class APIRequest{
    
    let session = URLSession(configuration: .default)
    var dataTask:URLSessionDataTask? = nil
    
    func getPlanets(pageUrl: String?) -> Observable<PlanetDataModel> {
        let requestUrlString = (pageUrl == nil) ? (Constants.URL.base + Constants.EndPoints.urlListPlanets) : pageUrl
        return Observable.create{observer in
            self.dataTask = self.session.dataTask(with: URL(string: requestUrlString!)! , completionHandler: {
                (data, response, error) in
                do {
                    let model: PlanetDataModel = try JSONDecoder().decode(PlanetDataModel.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            })
            self.dataTask?.resume()
            return Disposables.create{
                self.dataTask?.cancel()
            }
        }
    }
}
