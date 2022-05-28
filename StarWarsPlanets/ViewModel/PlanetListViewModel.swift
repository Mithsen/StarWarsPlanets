//
//  PlanetViewModel.swift
//  SyscoAssignment
//
//  Created by Mithsen on 2022-05-27.
//

import Foundation


import RxCocoa
import RxSwift

final class PlanetListViewModel {
    
    private weak var view: PlanetListViewController?
    private weak var router: PlanetListRouter?
    
    private let disposeBag = DisposeBag()
    private let apiRequest = APIRequest()

    let items = BehaviorRelay<[PlanetDetail]>(value: [])

    let fetchMoreDatas = PublishSubject<Void>()
    let refreshControlAction = PublishSubject<Void>()
    let refreshControlCompelted = PublishSubject<Void>()
    let isLoadingSpinnerAvaliable = PublishSubject<Constants.PlanetListSpinningType>()

    private var nextPage:String?
    private var previousPage:String?
    
    private var isPaginationRequestStillResume = false
    private var isRefreshRequstStillResume = false
    private var pageLoading = false
    
    func bind(view: PlanetListViewController, router: PlanetListRouter) {
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
        
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchPlanetData(isRefreshControl: false)
        }
        .disposed(by: disposeBag)

        refreshControlAction.subscribe { [weak self] _ in
            self?.refreshControlTriggered()
        }
        .disposed(by: disposeBag)
    }

    private func fetchPlanetData(isRefreshControl: Bool) {
        if isPaginationRequestStillResume || isRefreshRequstStillResume { return }
        self.isRefreshRequstStillResume = isRefreshControl
        
        if self.nextPage == nil && self.previousPage != nil  {
            isPaginationRequestStillResume = false
            return
        }
       
        isPaginationRequestStillResume = true
        
        if isRefreshControl {
            isLoadingSpinnerAvaliable.onNext(.none)
        } else if (self.nextPage == nil && self.previousPage == nil)  || isRefreshControl {
            isLoadingSpinnerAvaliable.onNext(.main)
        } else {
            isLoadingSpinnerAvaliable.onNext(.footer)
        }
        
        apiRequest.getPlanets(pageUrl: self.nextPage).subscribe(
            onNext: { [self] (dummyResponse) in
                DispatchQueue.main.async {
                    self.handlePlanetData(data: dummyResponse)
                    self.isLoadingSpinnerAvaliable.onNext(.none)
                    self.isPaginationRequestStillResume = false
                    self.isRefreshRequstStillResume = false
                    self.refreshControlCompelted.onNext(())
                    self.pageLoading = false
                }
                
            }, onError: {(error) in
                print(error.localizedDescription)
                self.pageLoading = false
            }, onCompleted: {
                print("Completed")
            }
        ).disposed(by: disposeBag)
    }

    private func handlePlanetData(data: PlanetDataModel) {
        if (nextPage == nil && previousPage == nil), let finalData = data.results {
            items.accept(finalData)
        } else if let data = data.results {
            let oldDatas = items.value
            items.accept(oldDatas + data)
        }
        nextPage = data.next
        previousPage = data.previous
    }

    private func refreshControlTriggered() {
        isPaginationRequestStillResume = false
        nextPage = nil
        previousPage = nil
        items.accept([])
        fetchPlanetData(isRefreshControl: true)
    }
}
